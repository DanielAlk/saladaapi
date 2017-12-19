class PlanSerializer < ActiveModel::Serializer
  attributes :id, :mercadopago_plan_id, :plan_group, :name, :title, :kind, :price, :frequency, :frequency_type, :application_fee, :status, :description, :auto_recurring, :metadata, :mercadopago_plan
end