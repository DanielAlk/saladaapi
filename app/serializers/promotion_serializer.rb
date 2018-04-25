class PromotionSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :kind, :description, :price, :duration, :duration_type, :created_at, :updated_at
end
