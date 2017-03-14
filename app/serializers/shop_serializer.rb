class ShopSerializer < ActiveModel::Serializer
  attributes :id, :description, :location, :location_detail, :location_floor, :location_row, :gallery_name, :number_id, :letter_id, :fixed, :opens, :condition, :status, :rating, :image, :cover, :shed_title, :user_id
  has_one :user, if: -> { instance_options[:complete] || instance_options[:owner] }
  has_one :shed
  has_one :category
  has_many :products, if: -> { !instance_options[:complete] && instance_options[:owner] } do
  	object.products
  end
  has_many :products, if: -> { instance_options[:complete] && !instance_options[:owner] } do
  	object.products.published
  end
end
