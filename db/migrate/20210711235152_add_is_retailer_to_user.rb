class AddIsRetailerToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_retailer, :boolean, default: false
  end
end
