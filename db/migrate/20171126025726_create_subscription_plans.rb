class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.string :title
      t.integer :kind, default: 0
      t.decimal :price, precision: 8, scale: 2
      t.references :subscription, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
