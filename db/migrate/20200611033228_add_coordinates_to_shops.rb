class AddCoordinatesToShops < ActiveRecord::Migration
  def change
    add_column :shops, :latitude, :decimal, precision: 12, scale: 9
    add_column :shops, :longitude, :decimal, precision: 12, scale: 9
  end
end
