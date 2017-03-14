class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :transaction_amount, :mercadopago_preference, :payment_info, :init_point, :collection_id, :collection_status, :collection_status_detail, :preference_id, :payment_type, :updated_at, :created_at
  has_one :user
  has_one :payable
end
