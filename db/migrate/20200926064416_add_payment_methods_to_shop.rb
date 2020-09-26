class AddPaymentMethodsToShop < ActiveRecord::Migration
  def change
    add_column :shops, :payment_methods, :string
    add_column :shops, :shipping_company, :string
  end
end
