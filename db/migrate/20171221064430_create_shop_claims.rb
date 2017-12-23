class CreateShopClaims < ActiveRecord::Migration
  def change
    create_table :shop_claims do |t|
      t.integer :status, default: 0
      t.references :user, index: true, foreign_key: true
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
