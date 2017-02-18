class ShopSerializer < ActiveModel::Serializer
  attributes :id, :description, :location, :location_detail, :between_down, :between_up, :number_id, :letter_id, :fixed, :opens, :condition, :status, :rating, :image, :cover, :shed_title
  has_one :user, if: -> { instance_options[:complete] }
  has_one :shed, if: -> { instance_options[:complete] }
  has_one :category, if: -> { instance_options[:complete] }
  has_many :products, if: -> { instance_options[:complete] }
end
