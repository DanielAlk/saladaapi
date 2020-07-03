class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :ancestry, :user_role, :created_at, :updated_at
end
