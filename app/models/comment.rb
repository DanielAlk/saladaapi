class Comment < ActiveRecord::Base
	include Filterable
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :receiver, class_name: :User
  belongs_to :interaction, autosave: true
  has_one :answer, as: :commentable, class_name: :Comment, dependent: :destroy

  enum role: [:question, :answer]
  enum status: [:unanswered, :answered]

  validates :user, :commentable, presence: true
  validates :text, presence: true, length: { maximum: 140 }

  before_create :save_receiver
  before_create :mark_as_answer, if: :is_answer?
  after_create :handle_interaction
  after_create :push_notificate
  before_destroy :assign_new_last_comment_to_interaction, if: -> { self.interaction.last_comment == self }
  after_destroy :destroy_interaction_if_empty, if: -> { self.interaction.last_comment.blank? }

  def next
  	Comment.where('(created_at < ?) AND (commentable_id = ?) AND (commentable_type = ?)', self.created_at, self.commentable_id, self.commentable_type).order(created_at: :desc).first
  end

  def prev
  	Comment.where('(created_at > ?) AND (commentable_id = ?) AND (commentable_type = ?)', self.created_at, self.commentable_id, self.commentable_type).order(created_at: :desc).first
  end

  def is_answer?
  	commentable_type == 'Comment'
  end

  def is_root?
    commentable_type != 'Comment'
  end

  def root_commentable
    if is_root?
      commentable
    else
      commentable.try(:commentable)
    end
  end

  def answered!
  	self.read = true
  	super
  end

  def to_hash(flag = nil)
    comment = JSON.parse(self.to_json).deep_symbolize_keys
    if flag == :complete
      comment[:user] = self.user.to_hash
    end
    if flag == :for_user
      comment[:product] = question? ? self.commentable.try(:to_hash) : self.commentable.try(:commentable).try(:to_hash)
    end
    if [:complete, :for_user].include?(flag)
      if question? && answered?
        comment[:answer] = self.answer.try(:to_hash)
      elsif answer?
        comment[:question] = self.commentable.try(:to_hash)
      end
    end

    comment
  end

  private
    def push_notificate
      self.commentable.user.increment!(:badge_number)
      contents = {
        user_id: self.commentable.user.id,
        title: root_commentable.title,
        message: is_root? ? self.user.name + ' hizo una pregunta.' : 'Te han contestado tu pregunta.',
        data: {
          state: is_root? ? 'app.thread' : 'app.comment',
          params: {
            id: root_commentable.id
          }
        },
        badge_number: self.commentable.user.badge_number,
        buttons: [ 'Ver' ]
      }
      PushJob.perform_async(contents)
    end

  	def mark_as_answer
  		self.role = :answer
  		self.commentable.answered!
  	end

    def save_receiver
      self.receiver = self.commentable.user
    end

    def assign_new_last_comment_to_interaction
      self.interaction.last_comment = self.interaction.comments.order(created_at: :desc).second
      self.interaction.save
    end

    def destroy_interaction_if_empty
      self.interaction.destroy
    end

    def handle_interaction
      self.interaction = Interaction.find_by(product: self.root_commentable, user: self.user) if self.is_root?
      self.interaction = Interaction.find_by(product: self.root_commentable, user: self.commentable.user) if self.is_answer?
      unless self.interaction.present?
        self.interaction = Interaction.new(product: self.root_commentable, user: self.user)
      end
      self.interaction.last_comment = self
      self.save
    end

end
