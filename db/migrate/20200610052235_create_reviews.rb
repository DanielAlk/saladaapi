class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :product
      t.text :text
      t.integer :stars
      t.boolean :is_visible

      t.timestamps null: false
    end
  end
end
