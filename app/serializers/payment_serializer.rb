class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :kind, :transaction_amount, :installments, :shipment_cost, :payment_method_id, :token, :additional_info, :mercadopago_payment, :mercadopago_payment_id, :status, :status_detail, :save_address, :save_card, :mercadopago_message, :updated_at, :created_at
  has_one :user
  has_one :payable
  has_one :promotionable
end