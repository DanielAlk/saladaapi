class AddPackagePropertiesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_package, :boolean, default: false
    add_column :products, :package_amount, :integer
    add_column :products, :package_price, :decimal, precision: 8, scale: 2
  end
end
