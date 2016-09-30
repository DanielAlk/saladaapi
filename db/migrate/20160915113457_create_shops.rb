class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.references :user, index: true, foreign_key: true
      t.references :shed, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.string :description
      t.integer :location
      t.string :location_detail
      t.string :between_down
      t.string :between_up
      t.integer :number_id
      t.string :letter_id
      t.boolean :fixed
      t.string :opens
      t.integer :condition
      t.integer :rating
      t.attachment :image
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
