class Interaction < ActiveRecord::Base
  belongs_to :owner, class_name: :User
  belongs_to :user
  belongs_to :product
  belongs_to :last_comment, class_name: :Comment, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_create :save_inherited_values
  before_update :change_owner, if: :owner_id_changed?

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

    def change_owner
      save_inherited_values
      comments.answer.update_all(user_id: self.product.user.id)
      comments.question.update_all(receiver_id: self.product.user.id)
    end

end
