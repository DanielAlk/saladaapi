class ProductBuyClick < ActiveRecord::Base
  include Filterable
  belongs_to :user
  belongs_to :product

  validates :user, :product, presence: true

  filterable range: [:created_at]
end
