class PlanGroup < ActiveRecord::Base
	include Filterable
	has_many :plans

	enum kind: Plan.kinds
	enum subscriptable_role: User.roles
	enum premium_type: User.premium_types

	filterable search: [ :title ]

	validates :title, presence: true, length: { minimum: 4, maximum: 50 }
	validates :starting_price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 999999.99 }, allow_blank: true

	before_save :set_starting_price

	def self.available_for_user(user)
		user.available_plan_groups
	end

	def self.available_for_user_id(user_id)
		User.find(user_id).try(:available_plan_groups)
	end

	def to_hash(flag = nil)
		JSON.parse(self.to_json).deep_symbolize_keys
	end

	private
		def set_starting_price
			self_plans = Plan.where(plan_group: self)
			if self_plans.present?
				self.starting_price = self_plans.map{ |plan| plan.price }.min
			end
		end

end
