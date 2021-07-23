class AddExpiresAtToShop < ActiveRecord::Migration
  def change
    add_column :shops, :expires_at, :datetime, default: nil
  end
end
