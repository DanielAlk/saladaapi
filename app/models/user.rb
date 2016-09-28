class User < ActiveRecord::Base
  # Include default devise modules.
  # devise :database_authenticatable, :registerable,
  #         :recoverable, :rememberable, :trackable, :validatable,
  #         :confirmable, :omniauthable
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_attached_file :avatar, styles: { medium: "300x300#", small: "140x140#", thumb: "80x80#" }
  validates_attachment :avatar, content_type: { content_type: /\Aimage\/.*\Z/ }

  has_many :shops
  serialize :metadata

  before_update :save_avatar_url

  enum role: [ :client, :seller ]
  enum gender: [ :male, :female ]

  def metadata=(metadata)
  	if metadata.respond_to?(:each)
  		write_attribute(:metadata, metadata)
  	elsif (parsed = JSON.parse(metadata)).present?
  		write_attribute(:metadata, parsed)
  	end
  end

  protected
    def save_avatar_url
      if self.avatar_file_name_changed?
        image_url = ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.avatar.url(:medium)
        self.image = image_url
      end
    end
end
