class ImageSerializer < ActiveModel::Serializer
  attributes :id, :title, :item, :position
  has_one :imageable
end
