class UserSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :email, if: :medium
  attribute :role, if: :medium
  attribute :badge_number, if: :complete
  attribute :address, if: :complete
  attribute :avatar_content_type, if: :complete
  attribute :avatar_file_name, if: :complete
  attribute :avatar_file_size, if: :complete
  attribute :avatar_updated_at, if: :complete
  attribute :birthday, if: :complete
  attribute :gender, if: :complete
  attribute :id_number, if: :complete
  attribute :id_type, if: :complete
  attribute :image, if: :complete
  attribute :io_uid, if: :complete
  attribute :locality, if: :complete
  attribute :metadata, if: :complete
  attribute :nickname, if: :complete
  attribute :phone_number, if: :complete
  attribute :provider, if: :complete
  attribute :special, if: :complete
  attribute :uid, if: :complete
  attribute :product_limit, if: :complete
  attribute :product_image_limit, if: :complete
  attribute :shop_limit, if: :complete
  attribute :unanswered_questions_count, if: :complete
  attribute :unread_answers_count, if: :complete
  attribute :has_subscriptions_available, if: :complete

  def has_subscriptions_available
    object.has_subscriptions_available?
  end

  def medium
  	instance_options[:minimal] != true
  end

	def complete
		instance_options[:minimal] != true && instance_options[:medium] != true
	end
end