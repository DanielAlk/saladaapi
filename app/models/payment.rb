class Payment < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include MercadoPagoConcern
  belongs_to :user
  belongs_to :payable, polymorphic: true
  belongs_to :promotionable, polymorphic: true

  validates :user, presence: true, if: :new_record?
  validates :payable, presence: true
  validates :transaction_amount, presence: true

  before_create :inherit_kind
  before_create :create_cash_payment, if: :cash?
  after_create :create_mercadopago_user, if: :debit?
  after_create :create_mercadopago_payment, if: :debit?
  after_save :promotionable_handle_payment, if: :is_new_or_status_changed?

  serialize :mercadopago_payment
  serialize :additional_info

  enum kind: [ :debit, :cash ]
  enum status: [ :pending, :approved, :authorized, :in_process, :in_mediation, :rejected, :cancelled, :refunded, :charged_back, :failed ]
  
	def self.find_mp(mercadopago_payment_id)
    request = $mp.get("/v1/payments/"+mercadopago_payment_id)
    if request['status'].try(:to_i) == 200
      mp_payment = request['response'].deep_symbolize_keys
      payment = self.find(mp_payment[:external_reference])
      if payment.present?
        payment.mercadopago_payment = mp_payment
        payment.mercadopago_payment_id = mp_payment[:id]
        payment.status = mp_payment[:status]
        payment.status_detail = mp_payment[:status_detail]
        if payment.status_changed? && [:pending, :authorized, :in_process].include?(payment.status_was.try(:to_sym))
          if payment.user.present?
            payment.user.handle_payment(payment)
          end
        end
        payment.save
        return payment
      end
    end
    return false
  end

  def status=(s)
    if self.class.statuses[s].present?
      self[:status] = self.class.statuses[s]
    else
      self[:status] = self.class.statuses[:failed]
    end
  end

  def create_mercadopago_user
    user.create_mercadopago_user
  end
  
  def create_mercadopago_payment
    self.additional_info = {
      payer: {
        first_name: user.first_name,
        last_name: user.last_name,
        phone: {
          number: user.phone_number
        },
        address: {
          street_name: user.address
        } 
      }
    }
  	paymentData = {
  		transaction_amount: transaction_amount.to_f,
  		token: token,
  		description: "SaladaApi Payments",
  		installments: installments,
  		payment_method_id: payment_method_id,
  		payer: {
  			id: user.customer_id
			},
			external_reference: id,
			statement_descriptor: "Compra en SaladaApi",
			additional_info: additional_info
  	}
  	if Rails.env.production? #mercadopago sandbox fails if localhost:3000 is in the notification_url
  		paymentData[:notification_url] = notifications_mercadopago_url(protocol: ENV['webapp_protocol'], host: ENV['webapp_domain'])
  	end
  	self.mercadopago_payment = $mp.post("/v1/payments", paymentData)['response'].try(:deep_symbolize_keys);
    self.mercadopago_payment_id = self.mercadopago_payment[:id]
    self.status = self.mercadopago_payment[:status]
    self.status_detail = self.mercadopago_payment[:status_detail]
    
    user.handle_payment(self)

    if self.failed? && self.mercadopago_payment[:status].try(:to_i) == 400 && self.mercadopago_payment[:cause][0][:code].try(:to_i) == 2002 #customer_not_found
      user.update_attribute(:customer_id, nil)
    end

    self.save
  end

  def friendly_status
    { pending: 'Pendiente', approved: 'Aprobado', authorized: 'Autorizado', in_process: 'En proceso', in_mediation: 'En mediación', rejected: 'Rechazado', cancelled: 'Cancelado', refunded: 'Devuelto', charged_back: 'Contracargado', failed: 'No procesado' }[status.try(:to_sym)]
  end

  private
    def inherit_kind
      self.kind = self.payable.kind
    end

    def create_cash_payment
      self.status = :pending
    end

    def promotionable_handle_payment
      self.promotionable.handle_payment(self)
    end

    def is_new_or_status_changed?
      new_record? || status_changed?
    end
end
