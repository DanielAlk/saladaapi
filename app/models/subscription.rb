class Subscription < ActiveRecord::Base
	alias_attribute :plans, :subscription_plans
	has_many :subscription_plans, dependent: :destroy

	enum subscriptable_role: User.roles
end
