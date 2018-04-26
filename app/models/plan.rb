class Plan < ActiveRecord::Base
	belongs_to :plan_group
	has_many :subscriptions, dependent: :destroy
	has_many :invoices, dependent: :destroy

	enum kind: [ :automatic_debit, :cash ]
	enum status: [ :active, :inactive, :cancelled, :failed ]
	enum frequency_type: [ :days, :months ]

	serialize :auto_recurring
	serialize :metadata
	serialize :mercadopago_plan

	validates :title, presence: true, length: { minimum: 4, maximum: 50 }
	validates :price, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999.99 }

	before_update :update_mercadopago_plan, if: :automatic_debit?

	def self.create_mercadopago_plans
		self.all.each do |plan|
			plan.create_mercadopago_plan
		end
	end

	def status=(s)
	  if self.class.statuses[s].present?
	    self[:status] = self.class.statuses[s]
	  else
	    self[:status] = self.class.statuses[:failed]
	  end
	end

	def update_mercadopago_plan
		if mercadopago_plan_id.present? && price_changed?
			request = $mp.put("/v1/plans/#{mercadopago_plan_id}", {
				auto_recurring: {
					transaction_amount: price.to_f
				}
			})
			if request['status'].try(:to_i) == 200
				plan = request['response'].deep_symbolize_keys
				self.mercadopago_plan = plan
				self.mercadopago_plan_id = plan[:id]
				self.application_fee = plan[:application_fee]
				self.status = plan[:status]
				self.auto_recurring = plan[:auto_recurring]
				self.metadata = plan[:metadata]
			end
		end
	end

	def create_mercadopago_plan
		if automatic_debit?
			request = $mp.post('/v1/plans', {
				external_reference: id,
				description: description,
				auto_recurring: {
					frequency: frequency,
					frequency_type: frequency_type,
					transaction_amount: price.to_f
				}
			})
			if request['status'].try(:to_i) == 201
				plan = request['response'].deep_symbolize_keys
				self.mercadopago_plan = plan
				self.mercadopago_plan_id = plan[:id]
				self.application_fee = plan[:application_fee]
				self.status = plan[:status]
				self.auto_recurring = plan[:auto_recurring]
				self.metadata = plan[:metadata]
				self.save
			end
		end
	end

	def to_hash(flag = nil)
		plan = JSON.parse(self.to_json).deep_symbolize_keys
		plan[:plan_group] = self.plan_group.to_hash
		plan
	end
end
