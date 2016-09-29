class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.references :shop, index: true, foreign_key: true
      t.string :title
      t.integer :stock
      t.decimal :price, precision: 8, scale: 2
      t.text :description

      t.timestamps null: false
    end
  end
end
