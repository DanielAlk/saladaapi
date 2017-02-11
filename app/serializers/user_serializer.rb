class UserSerializer < ActiveModel::Serializer
  attributes :id, :badge_number, :address, :avatar_content_type, :avatar_file_name, :avatar_file_size, :avatar_updated_at, :birthday, :email, :gender, :id_number, :id_type, :image, :io_uid, :locality, :metadata, :name, :nickname, :phone_number, :provider, :role, :uid, :unanswered_comments_count, :unread_responses_count
end