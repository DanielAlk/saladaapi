class User < ActiveRecord::Base
  # Include default devise modules.
  # devise :database_authenticatable, :registerable,
  #         :recoverable, :rememberable, :trackable, :validatable,
  #         :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  include IonicApi

  has_attached_file :avatar, styles: { medium: "300x300#", small: "140x140#", thumb: "80x80#" }
  validates_attachment :avatar, content_type: { content_type: /\Aimage\/.*\Z/ }

  has_many :shops, dependent: :destroy
  has_many :products
  has_many :comments
  has_many :incoming_comments, foreign_key: :receiver_id, class_name: :Comment, dependent: :destroy
  has_many :incoming_interactions, foreign_key: :owner_id, class_name: :Interaction, dependent: :destroy
  has_many :outgoing_interactions, class_name: :Interaction, dependent: :destroy
  serialize :metadata

  validates :name, :email, :gender, :birthday, :id_type, :id_number, :locality, :address, :phone_number, :role, presence: true

  enum role: [ :client, :seller ]
  enum gender: [ :male, :female ]

  before_create :ionic_create
  before_destroy :ionic_destroy

  def metadata=(metadata)
  	if metadata.respond_to?(:each)
  		write_attribute(:metadata, metadata)
  	elsif (parsed = JSON.parse(metadata)).present?
  		write_attribute(:metadata, parsed)
  	end
  end

  def image
    if self.avatar.present?
      ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.avatar.url(:medium)
    else
      self[:image]
    end
  end

  def unanswered_questions_count
    self.incoming_comments.question.unanswered.count
  end

  def unread_answers_count
    self.incoming_comments.answer.where(read: false).count
  end

  def interacted_products_as(interact_as)
    where_clause = 'interactions.user_id' if interact_as == :user
    where_clause = 'interactions.owner_id' if interact_as == :owner
    Product.published.distinct.select('products.*, MAX(interactions.updated_at) as interaction_updated_at').joins(:interactions).where(where_clause => self).group(:product_id).order('interaction_updated_at DESC')
  end
  
  def token_validation_response
    UserSerializer.new( self, root: false )
  end

  def ionic_create(password = nil)
    password = password || self.password
    if self.image?
      user_data = { app_id: ionic_app_id, name: self.name, email: self.email, password: password, image: self.image }
    else
      user_data = { app_id: ionic_app_id, name: self.name, email: self.email, password: password }
    end
    if (response = ionic_api :users, :post, user_data).present?
      self.io_uid = response['data']['uuid']
      self.image = response['data']['details']['image'] unless self.image?
    end
  end

  def ionic_check
    ionic_api(:users, :get, {}, self.io_uid).present?
  end

  private
    def ionic_destroy
      ionic_api :users, :delete, {}, self.io_uid
      true #delete regardless of ionic response
    end
end
