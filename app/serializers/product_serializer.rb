class ProductSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :stock, :price, :description, :cover, :status, :special
  attribute :unanswered_questions_count, if: -> { instance_options[:interaction] == :owner }
  attribute :unread_answers_count, if: -> { instance_options[:interaction] == :user }
  attribute :interaction_updated_at, if: -> { instance_options[:interaction].present? }
  attribute :comments_count, if: -> { instance_options[:complete] }
  has_one :user, if: -> { instance_options[:complete] }
  has_one :category, if: -> { instance_options[:complete] }
  has_one :shop, if: -> { instance_options[:complete] }
  has_many :images, if: -> { instance_options[:complete] }

  def unanswered_questions_count
  	object.interactions.select(:id).inject(0){|sum,p| sum + p.unanswered_questions_count}
  end

  def unread_answers_count
  	object.interactions.select(:id).inject(0){|sum,p| sum + p.unread_answers_count(current_user)}
  end
end
