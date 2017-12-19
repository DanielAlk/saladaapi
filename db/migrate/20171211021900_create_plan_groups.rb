class CreatePlanGroups < ActiveRecord::Migration
  def change
    create_table :plan_groups do |t|
      t.string :name
      t.string :title
      t.text :description
      t.integer :kind, default: 0
      t.integer :subscriptable_role
      t.decimal :starting_price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
