class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :starting_price, :plans
end
