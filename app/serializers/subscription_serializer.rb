class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :mercadopago_subscription_id, :mercadopago_plan_id, :plan, :user, :kind, :payer, :payment_method_id, :next_payment_date, :token, :application_fee, :status, :description, :start_date, :end_date, :metadata, :charges_detail, :setup_fee, :mercadopago_subscription
end
