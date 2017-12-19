class Plan < ActiveRecord::Base
	belongs_to :plan_group
	has_many :subscriptions, dependent: :destroy
	has_many :invoices, dependent: :destroy

	enum kind: [ :automatic_debit, :cash ]
	enum status: [ :active, :inactive, :cancelled ]
	enum frequency_type: [ :days, :months ]

	serialize :auto_recurring
	serialize :metadata
	serialize :mercadopago_plan

	def self.create_mercadopago_plans
		self.all.each do |plan|
			plan.create_mercadopago_plan
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
end
