class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :tel, :message, :role, :subject, :read, :created_at, :updated_at
end
