class SubscriptionPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :kind, :price
end
