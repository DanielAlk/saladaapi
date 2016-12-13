class ProductSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :stock, :price, :description, :cover, :status, :special, :comments_count, :unanswered_comments_count
  has_one :user
  has_one :category
  has_one :shop
  has_many :images
end
