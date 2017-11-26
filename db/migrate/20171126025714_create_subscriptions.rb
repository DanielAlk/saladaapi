class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.string :title
      t.text :description
      t.decimal :starting_price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
