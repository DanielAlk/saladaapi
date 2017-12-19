class Invoice < ActiveRecord::Base
	belongs_to :subscription
	belongs_to :plan
	belongs_to :user

	enum status: [ :pending, :dunning, :paid, :unpaid, :cancelled ]

	serialize :payer
	serialize :metadata
	serialize :payments
	serialize :mercadopago_invoice

	before_create :referenciate, if: :subscription

	def update_from_mercadopago(invoice, flag)
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
		
		self.save unless flag == :dont_save
	end

	private
		def referenciate
			self.user = subscription.user
			self.plan = subscription.plan
		end
end
