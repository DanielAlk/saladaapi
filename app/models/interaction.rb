class Interaction < ActiveRecord::Base
  belongs_to :owner, class_name: :User
  belongs_to :user
  belongs_to :product
  belongs_to :last_comment, class_name: :Comment
  has_many :comments, dependent: :destroy

  before_create :save_inherited_values
  before_update :save_last_comment_created_at

  def unread_answers_count
  	self.comments.answer.where(read: false).count
  end

  def unanswered_questions_count
  	self.comments.question.unanswered.count
  end

  private
  	def save_inherited_values
  		self.owner = self.product.user
  		self.last_comment_created_at = self.last_comment.created_at if self.last_comment.present?
  	end

  	def save_last_comment_created_at
  		self.last_comment_created_at = self.last_comment.created_at rescue nil
  	end
end
