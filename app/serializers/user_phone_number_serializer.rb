class UserPhoneNumberSerializer < ActiveModel::Serializer
  attributes :id, :user, :phone_number, :created_at, :updated_at
end
