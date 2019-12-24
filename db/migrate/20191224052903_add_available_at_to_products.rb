class AddAvailableAtToProducts < ActiveRecord::Migration
  def change
    add_column :products, :available_at, :date, default: nil
  end
end
