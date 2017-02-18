class CommentSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :role, :status, :answer, :read, :created_at
  has_one :commentable
  has_one :user
  has_one :receiver
  #has_one :interaction
end
