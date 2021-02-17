class ProductBuyClickSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :product_id, :created_at, :updated_at
  has_one :user
  has_one :product
end
