class Subscription < ActiveRecord::Base
	alias_attribute :plans, :subscription_plans
	has_many :subscription_plans, dependent: :destroy
end
