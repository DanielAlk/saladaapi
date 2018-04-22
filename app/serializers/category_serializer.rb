class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :ancestry, :created_at, :updated_at
end
