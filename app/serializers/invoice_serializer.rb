class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :mercadopago_invoice_id, :mercadopago_subscription_id, :mercadopago_plan_id, :subscription, :plan, :user, :payer, :application_fee, :status, :description, :metadata, :payments, :debit_date, :next_payment_attempt, :mercadopago_invoice
end
