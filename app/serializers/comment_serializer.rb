class CommentSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :role, :status, :response, :read
  has_one :commentable
  has_one :user
end
