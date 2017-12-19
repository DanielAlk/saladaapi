class PlanGroup < ActiveRecord::Base
	has_many :plans

	enum kind: Plan.kinds
	enum subscriptable_role: User.roles

	def self.available_for_user(user)
		user.available_plan_groups
	end

end
