class AddWholesalerPropertiesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_retailer, :boolean, default: false
    add_column :products, :wholesaler_amount, :integer
    add_column :products, :shipping_amount, :integer
    add_column :products, :retailer_price, :decimal, precision: 8, scale: 2
    add_column :products, :shipping_price, :decimal, precision: 8, scale: 2
  end
end
