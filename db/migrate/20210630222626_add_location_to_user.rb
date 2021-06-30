class AddLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :integer, default: 0
  end
end
