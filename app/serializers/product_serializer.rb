class ProductSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :stock, :price, :description, :cover, :status, :special, :is_retailer, :wholesaler_amount, :shipping_amount, :retailer_price, :shipping_price, :video_id, :rating, :provider_product, :minimum_amount, :available_at
  attribute :unanswered_questions_count, if: -> { instance_options[:interaction] == :owner }
  attribute :unread_answers_count, if: -> { instance_options[:interaction] == :user }
  attribute :interaction_updated_at, if: -> { instance_options[:interaction].present? }
  attribute :comments_count, if: -> { instance_options[:complete] }
  attribute :last_comment, if: -> { instance_options[:complete] && object.comments.present? }
  has_many :images
  has_one :shop
  has_one :user, if: -> { instance_options[:complete] }
  has_one :category

  def unanswered_questions_count
  	object.interactions.select(:id).inject(0){|sum,p| sum + p.unanswered_questions_count}
  end

  def unread_answers_count
  	object.interactions.select(:id).inject(0){|sum,p| sum + p.unread_answers_count(current_user)}
  end

  def last_comment
    serializer = CommentSerializer.new(object.comments.last, {scope: current_user})
    def serializer.current_user() scope end
    serializer
  end
end
