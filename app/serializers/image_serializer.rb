class ImageSerializer < ActiveModel::Serializer
  attributes :id, :title, :item, :position, :url
  has_one :imageable
end
