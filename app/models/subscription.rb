class Subscription < ActiveRecord::Base
	belongs_to :plan
	belongs_to :user
	has_many :invoices, dependent: :destroy

	enum status: [ :authorized, :paused, :finished, :cancelled ]
	enum kind: [ :automatic_debit, :cash ]

	serialize :payer
	serialize :metadata
	serialize :charges_detail
	serialize :mercadopago_subscription

	validates :plan, :user, presence: true

	before_create :inherit_kind
	before_create :create_mercadopago_subscription, if: :automatic_debit?
	before_create :create_cash_subscription, if: :cash?
	after_save :user_handle_subscription, if: :is_new_or_status_changed?

	def self.find_mp(mercadopago_subscription_id)
		request = $mp.get('/v1/subscriptions/' + mercadopago_subscription_id)
		if request['status'].try(:to_i) == 200
			mp_subscription = request['response'].deep_symbolize_keys
			subscription = self.find(mp_subscription[:external_reference])
			if subscription.present?
				subscription.update_from_mercadopago(mp_subscription)
				return subscription
			end
		end
		return false
	end

	def get_from_mercadopago
		request = $mp.get('/v1/subscriptions/' + mercadopago_subscription_id)
		if request['status'].try(:to_i) == 200
			return request['response'].deep_symbolize_keys
		else
			return false
		end
	end

	def create_mercadopago_subscription
		self.user.create_mercadopago_user
		self.user.default_card = self.token
		subscription_data = {
			external_reference: self.id,
			plan_id: self.plan.mercadopago_plan_id,
			payer: {
				id: self.user.customer_id
			}
		}
		request = $mp.post('/v1/subscriptions', subscription_data)
		if request['status'].try(:to_i) == 201
			subscription = request['response'].deep_symbolize_keys
			self.update_from_mercadopago(subscription)
		else
			return false
		end
	end

	def update_from_mercadopago(subscription)
		self.mercadopago_subscription = subscription
		self.mercadopago_subscription_id = subscription[:id]
		self.mercadopago_plan_id = subscription[:plan_id]
		self.payer = subscription[:payer]
		self.application_fee = subscription[:application_fee]
		self.status = subscription[:status]
		self.description = subscription[:description]
		self.start_date = subscription[:start_date]
		self.end_date = subscription[:end_date]
		self.metadata = subscription[:metadata]
		self.charges_detail = subscription[:charges_detail]
		self.setup_fee = subscription[:setup_fee]
		self.next_payment_date = subscription[:charges_detail][:next_payment_date]

		mp_invoices_id = self.charges_detail[:invoices].map{ |i| i[:id] }
		mp_invoices_id.each do |mp_id|
			request = $mp.get('/v1/invoices/' + mp_id)
			if request['status'].try(:to_i) == 200
				mp_invoice = request['response'].deep_symbolize_keys
				invoice = self.invoices.find_by(mercadopago_invoice_id: mp_id) || self.invoices.new
				invoice.update_from_mercadopago(mp_invoice, :dont_save)
			end
		end
	end

	def user_handle_subscription
		user.handle_subscription(self)
	end

	def destroy
		if self.automatic_debit? && !self.cancelled?
			request = $mp.put('/v1/subscriptions/' + mercadopago_subscription_id, { status: :cancelled })
			if request['status'].try(:to_i) == 200
				subscription = request['response'].deep_symbolize_keys
				self.update_from_mercadopago(subscription)
				self.save
			else
				subscription = self.get_from_mercadopago
				if subscription.present?
					self.update_from_mercadopago(subscription)
					self.save
				end
			end
		elsif self.cash? && !self.cancelled?
			self.cancelled!
		else
			super
		end
	end

	private
		def inherit_kind
			self.kind = self.plan.kind
		end

		def create_cash_subscription
			self.start_date = DateTime.now
			self.next_payment_date = DateTime.now + 3.days
			self.status = :paused
		end

		def is_new_or_status_changed?
			new_record? || status_changed?
		end
end
