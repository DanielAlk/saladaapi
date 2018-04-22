class Contact < ActiveRecord::Base
	include Filterable
	validates :name, :email, :message, :role, presence: true
	validates :message, presence: true

	filterable search: [ :name, :email ]

	enum role: [ :client, :seller ]
	enum subject: [ :contact ]

	scope :read, -> { where(read: true) }
	scope :unread, -> { where(read: false) }
end
