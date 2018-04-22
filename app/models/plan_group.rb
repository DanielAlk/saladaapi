class PlanGroup < ActiveRecord::Base
	include Filterable
	has_many :plans

	enum kind: Plan.kinds
	enum subscriptable_role: User.roles

	filterable search: [ :title ]

	def self.available_for_user(user)
		user.available_plan_groups
	end

	def self.available_for_user_id(user_id)
		User.find(user_id).try(:available_plan_groups)
	end

	def to_hash(flag = nil)
		JSON.parse(self.to_json).deep_symbolize_keys
	end

end
