class ShopSerializer < ActiveModel::Serializer
  attributes :id, :description, :location, :location_detail, :between_down, :between_up, :number_id, :letter_id, :fixed, :opens, :condition, :status, :rating, :image, :cover, :shed_title
  has_one :user
  has_one :shed
  has_one :category
  has_many :products
end
