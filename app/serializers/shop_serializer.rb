class ShopSerializer < ActiveModel::Serializer
  attributes :id, :description, :location, :location_detail, :location_floor, :location_row, :gallery_name, :number_id, :letter_id, :fixed, :opens, :condition, :status, :rating, :latitude, :longitude, :image, :cover, :shed_title, :user_id, :shed_id, :category_id, :user_name, :product_count, :payment_methods, :shipping_company, :location_string, :expires_at
  attribute :is_claimable, if: -> { instance_options[:complete] }
  has_one :user, if: -> { instance_options[:complete] || instance_options[:owner] }
  has_one :shed
  has_one :category
  has_many :products, if: -> { !instance_options[:complete] && instance_options[:owner] } do
  	object.products
  end
  has_many :products, if: -> { instance_options[:complete] && !instance_options[:owner] } do
  	object.products.published
  end

  def is_claimable
    object.is_claimable?
  end

  def user_name
    object.user.name
  end
end
