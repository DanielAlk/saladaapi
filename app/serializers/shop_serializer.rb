class ShopSerializer < ActiveModel::Serializer
  attributes :id, :description, :location, :location_detail, :between_down, :between_up, :number_id, :letter_id, :fixed, :opens, :status, :rating, :image
  has_one :user
  has_one :shed
  has_one :category
end
