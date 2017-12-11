class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :subscriptable_role, :starting_price, :plans
end
