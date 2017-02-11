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

  has_many :shops
  has_many :products
  has_many :comments
  serialize :metadata

  enum role: [ :client, :seller ]
  enum gender: [ :male, :female ]

  before_create :ionic_create

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

  def unanswered_comments_count
    self.products.inject(0){|sum,p| sum + p.unanswered_comments_count}
  end

  def unread_responses_count
    self.comments.question.answered.inject(0){|sum,c| sum + (c.response.read ? 0 : 1)}
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
end
