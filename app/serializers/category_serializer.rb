class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :ancestry
end
