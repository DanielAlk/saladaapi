class ShopClaimSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :shop_id, :status
end
