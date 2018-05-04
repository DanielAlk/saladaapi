class Contact < ActiveRecord::Base
	include Filterable
	validates :name, :email, :message, :role, presence: true
	validates :message, presence: true

	filterable search: [ :name, :email ]

	enum role: [ :client, :seller ]
	enum subject: [ :contact, :app_contact ]

	scope :read, -> { where(read: true) }
	scope :unread, -> { where(read: false) }

	before_save :set_subject_if_user_is_present

	private
		def set_subject_if_user_is_present
			if User.select(:id).where(email: self.email).present?
				self.subject = :app_contact
			end
		end
end
