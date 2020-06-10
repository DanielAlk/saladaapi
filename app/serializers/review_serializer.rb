class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :product_id, :text, :stars, :is_visible, :created_at, :updated_at
end
