class Contact < ActiveRecord::Base
	include Filterable
	validates :name, :email, :message, :role, presence: true
	validates :message, length: { minimum: 15 }

	filterable scopes: [ :role, :subject, :read ]
	filterable search: [ :name, :email, :message, :tel ]
	filterable order: [ :name, :email, :tel, :role, :subject ]

	enum role: [ :client, :seller ]
	enum subject: [ :contact ]

	scope :read, -> { where(read: true) }
	scope :unread, -> { where(read: false) }
end
