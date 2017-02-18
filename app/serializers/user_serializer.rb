class UserSerializer < ActiveModel::Serializer
  attributes :id, :badge_number, :address, :avatar_content_type, :avatar_file_name, :avatar_file_size, :avatar_updated_at, :birthday, :email, :gender, :id_number, :id_type, :image, :io_uid, :locality, :metadata, :name, :nickname, :phone_number, :provider, :role, :uid, :unanswered_questions_count, :unread_answers_count
  # how to define a serializer from within a serializer
  #private
  #	def product_collection_serializer(products)
  #		products.map do |product|
  #			serializer = ProductSerializer.new(product, {scope: current_user})
  #			def serializer.current_user() scope end
  #			serializer
  #		end
  #	end
end