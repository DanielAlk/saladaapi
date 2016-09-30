class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :stock, :price, :description, :cover, :status, :special
  has_one :user
  has_one :category
  has_one :shop
  has_many :images
end
