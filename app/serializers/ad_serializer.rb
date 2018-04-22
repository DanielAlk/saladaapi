class AdSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :actions, :cover_url, :special, :status, :kind, :created_at, :updated_at
end
