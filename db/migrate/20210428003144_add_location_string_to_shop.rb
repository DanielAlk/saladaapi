class AddLocationStringToShop < ActiveRecord::Migration
  def change
    add_column :shops, :location_string, :string
  end
end
