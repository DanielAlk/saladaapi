class SubscriptionPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :type, :price
end
