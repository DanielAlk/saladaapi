class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :tel, :message, :role, :subject, :read, :created_at, :updated_at
  attribute :user, if: -> { instance_options[:complete] && object.email }

  def user
  	User.find_by(email: object.email)
  end
end
