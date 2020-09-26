class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :text, :cover_url, :status, :video_id, :created_at, :updated_at
end
