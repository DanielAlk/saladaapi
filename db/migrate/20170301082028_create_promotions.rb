class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :title
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.integer :duration
      t.integer :duration_type, default: 0

      t.timestamps null: false
    end
  end
end
