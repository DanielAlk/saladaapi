class Payment < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :user
  belongs_to :payable, polymorphic: true
  validates :user, presence: true, if: :new_record?
  validates :payable, presence: true
  validates :transaction_amount, presence: true

  after_create :create_mercadopago_user
  after_create :create_mercadopago_payment

  serialize :mercadopago_payment
  serialize :additional_info
  
	def self.find_mp(mercadopago_payment_id)
    mp_payment = $mp.get("/v1/payments/"+mercadopago_payment_id)
    if mp_payment['status'].try(:to_i) == 200
      payment = self.find(mp_payment['response']['external_reference'])
      if payment.present?
        payment.mercadopago_payment = mp_payment['response']
        payment.mercadopago_payment_id = payment.mercadopago_payment['id']
        payment.status = payment.mercadopago_payment['status']
        payment.status_detail = payment.mercadopago_payment['status_detail']
        if payment.status_changed? && [:pending, :authorized, :in_process].include?(payment.status_was.try(:to_sym))
          if payment.status.try(:to_sym) == :approved && payment.user.present?
            payment.user.approved_payment(payment)
          end
        end
        payment.save
        return payment
      end
    end
    return false
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
			notification_url: notifications_payments_url(protocol: 'https', host: 'saladaapi.vxct1412.avnam.net'),
			additional_info: additional_info
  	}
  	if Rails.env.production? #mercadopago sandbox fails if localhost:3000 is in the notification_url
  		paymentData[:notification_url] = notifications_payments_url(protocol: ENV['webapp_protocol'], host: ENV['webapp_domain'])
  	end
  	self.mercadopago_payment = $mp.post("/v1/payments", paymentData)['response'];
    self.mercadopago_payment_id = self.mercadopago_payment['id']
    self.status = self.mercadopago_payment['status']
    self.status_detail = self.mercadopago_payment['status_detail']
    
    user.approved_payment(self) if self.status.try(:to_sym) == :approved

    if [:approved, :pending, :authorized, :in_process].include?(self.status.try(:to_sym))
      # payment_products.each do |payment_product|
      #   product = payment_product.product
      #   product.stock -= payment_product.quantity
      #   product.save
      # end
    elsif self.status == '400' && self.mercadopago_payment['cause'][0]['code'] == 2002 #customer_not_found
      user.update_attribute(:customer_id, nil)
    end
    save
  end

  def friendly_status
    friendly = { pending: 'Pendiente', approved: 'Aprobado', authorized: 'Autorizado', in_process: 'En proceso', in_mediation: 'En mediación', rejected: 'Rechazado', cancelled: 'Cancelado', refunded: 'Devuelto', charged_back: 'Contracargado' }[status.try(:to_sym)]
    if friendly.blank?
      friendly = 'No procesado'
    end
    friendly
  end
end
