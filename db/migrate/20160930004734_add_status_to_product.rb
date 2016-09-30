class AddStatusToProduct < ActiveRecord::Migration
  def change
    add_column :products, :status, :integer, default: 0
    add_column :products, :special, :integer, default: 0
  end
end
