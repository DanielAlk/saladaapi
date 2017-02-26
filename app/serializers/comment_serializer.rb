class CommentSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :role, :status, :answer, :read, :created_at
  attribute :shop, if: -> { instance_options[:complete] && object.commentable_type == 'Product' }
  has_one :commentable
  has_one :user
  has_one :receiver
  #has_one :interaction

  def shop
  	serializer = ShopSerializer.new(object.commentable.shop, {scope: current_user})
  	def serializer.current_user() scope end
  	serializer
  end
end
