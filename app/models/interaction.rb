class Interaction < ActiveRecord::Base
  belongs_to :owner, class_name: :User
  belongs_to :user
  belongs_to :product
  belongs_to :last_comment, class_name: :Comment
  has_many :comments, dependent: :destroy

  before_create :save_inherited_values

  def unread_answers_count(receiver)
  	self.comments.answer.where(read: false, receiver: receiver).count
  end

  def unanswered_questions_count
  	self.comments.question.unanswered.count
  end

  private
  	def save_inherited_values
  		self.owner = self.product.user
  	end
end
