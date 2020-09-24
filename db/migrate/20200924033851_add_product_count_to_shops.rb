class AddProductCountToShops < ActiveRecord::Migration
  def change
    add_column :shops, :product_count, :integer, default: 0
  end
end
