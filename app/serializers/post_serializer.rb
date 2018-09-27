class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :text, :cover_url, :status, :created_at, :updated_at
end
