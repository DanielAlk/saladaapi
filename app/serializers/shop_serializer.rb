class ShopSerializer < ActiveModel::Serializer
  attributes :id, :location, :location_detail, :between_down, :between_up, :number_id, :letter_id, :fixed, :opens, :status, :image
  has_one :user
  has_one :shed
  has_one :category
end
