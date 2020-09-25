class AdminNotificationSerializer < ActiveModel::Serializer
  attributes :id, :kind, :metadata, :status
  has_one :alertable
end
