class SubscriptionPlan < ActiveRecord::Base
  belongs_to :subscription

  enum kind: [ :automatic_debit, :cash ]
end
