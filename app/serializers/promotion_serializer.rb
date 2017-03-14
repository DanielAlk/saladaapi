class PromotionSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :price, :duration, :duration_type, :payment_url

  def payment_url
  	if current_user.present?
  		'http://192.168.1.103:4000/payments/new?user_id=' + current_user.id.to_s + '&promotion_id=' + object.id.to_s
  	end
  end
end
