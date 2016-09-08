class User < ActiveRecord::Base
  # Include default devise modules.
  # devise :database_authenticatable, :registerable,
  #         :recoverable, :rememberable, :trackable, :validatable,
  #         :confirmable, :omniauthable
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  serialize :metadata

  enum role: [ :client, :seller ]
  enum gender: [ :male, :female ]

  def metadata=(metadata)
  	if metadata.respond_to?(:each)
  		write_attribute(:metadata, metadata)
  	elsif (parsed = JSON.parse(metadata)).present?
  		write_attribute(:metadata, parsed)
  	end
  end
end
