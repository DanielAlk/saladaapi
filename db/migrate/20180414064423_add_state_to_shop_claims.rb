class AddStateToShopClaims < ActiveRecord::Migration
  def change
    add_column :shop_claims, :state, :integer, default: 1
  end
end
