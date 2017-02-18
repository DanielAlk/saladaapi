class InteractionSerializer < ActiveModel::Serializer
  attributes :id, :unread_answers_count, :unanswered_questions_count, :last_comment_created_at
  has_one :owner
  has_one :user
  has_one :product
  has_one :last_comment
  has_many :comments, if: -> { instance_options[:extended] }
end
