class Invoice < ActiveRecord::Base
	belongs_to :subscription
	belongs_to :plan
	belongs_to :user

	enum status: [ :pending, :dunning, :paid, :unpaid, :cancelled, :failed ]

	serialize :payer
	serialize :metadata
	serialize :payments
	serialize :mercadopago_invoice

	before_create :referenciate, if: :subscription

	def self.find_mp(mercadopago_invoice_id)
		request = $mp.get('/v1/invoices/' + mercadopago_invoice_id)
		if request['status'].try(:to_i) == 200
			mp_inovice = request['response'].deep_symbolize_keys
			invoice = self.find_by(mercadopago_invoice_id: mercadopago_invoice_id)
			if invoice.present?
				invoice.update_from_mercadopago(mp_inovice)
				invoice.save
				return invoice
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

	def update_from_mercadopago(invoice)
		self.mercadopago_invoice = invoice
		self.mercadopago_invoice_id = invoice[:id]
		self.mercadopago_subscription_id = invoice[:subscription_id]
		self.mercadopago_plan_id = invoice[:plan_id]
		self.payer = invoice[:payer]
		self.application_fee = invoice[:application_fee]
		self.status = invoice[:status]
		self.description = invoice[:description]
		self.metadata = invoice[:metadata]
		self.payments = invoice[:payments]
		self.debit_date = invoice[:debit_date]
		self.next_payment_attempt = invoice[:next_payment_attempt]
	end

	def to_hash(flag = nil)
		invoice = JSON.parse(self.to_json).deep_symbolize_keys
	end

	private
		def referenciate
			self.user = subscription.user
			self.plan = subscription.plan
		end
end
