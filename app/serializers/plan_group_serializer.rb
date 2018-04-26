class PlanGroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :title, :description, :kind, :subscriptable_role, :starting_price, :plans, :created_at, :updated_at
end
