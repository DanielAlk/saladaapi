class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.attachment :item
      t.references :imageable, polymorphic: true, index: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
