class SubscriptionPlanSerializer < ActiveModel::Serializer
  attributes :name, :title, :type, :price
end
