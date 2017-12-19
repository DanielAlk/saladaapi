class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :mercadopago_plan_id
      t.references :plan_group
      t.string :name
      t.string :title
      t.integer :kind, default: 0
      t.decimal :price, precision: 8, scale: 2
      t.integer :frequency
      t.integer :frequency_type, default: 0
      t.float :application_fee
      t.integer :status
      t.string :description
      t.text :auto_recurring
      t.text :metadata
      t.text :mercadopago_plan

      t.timestamps null: false
    end
    add_index :plans, :mercadopago_plan_id
  end
end
