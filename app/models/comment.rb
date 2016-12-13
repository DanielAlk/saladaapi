class Comment < ActiveRecord::Base
	include Filterable
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_one :comment, as: :commentable, dependent: :destroy

  enum role: [:question, :answer]
  enum status: [:unanswered, :answered]

  before_create :mark_as_answer, if: :is_response?

  def next
  	Comment.where('(created_at < ?) AND (commentable_id = ?) AND (commentable_type = ?)', self.created_at, self.commentable_id, self.commentable_type).order(created_at: :desc).first
  end

  def prev
  	Comment.where('(created_at > ?) AND (commentable_id = ?) AND (commentable_type = ?)', self.created_at, self.commentable_id, self.commentable_type).order(created_at: :desc).first
  end

  def is_response?
  	commentable_type == 'Comment'
  end

  def is_root?
    commentable_type != 'Comment'
  end

  def response
  	self.comment
  end

  def root_commentable
    if is_root?
      commentable
    else
      commentable.try(:commentable)
    end
  end

  def new_response(user)
    if is_root?
      self.comment = Comment.new(user: user)
    else
      self.commentable.comment = Comment.new(user: user)
    end
  end

  def answered!
  	self.read = true
  	super
  end

  private
  	def mark_as_answer
  		self.role = :answer
  		self.commentable.answered!
  	end
end
