class AddColumnsToShop < ActiveRecord::Migration
  def change
  	remove_column :shops, :between_down
  	remove_column :shops, :between_up
  	add_column :shops, :location_floor, :integer
  	add_column :shops, :location_row, :integer
  	add_column :shops, :gallery_name, :string
  end
end
