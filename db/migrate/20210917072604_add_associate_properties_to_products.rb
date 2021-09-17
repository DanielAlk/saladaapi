class AddAssociatePropertiesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_associate, :boolean, default: false
    add_column :products, :associate_amount, :integer
    add_column :products, :associate_price, :decimal, precision: 8, scale: 2
  end
end
