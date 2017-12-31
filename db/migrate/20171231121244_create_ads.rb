class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.text :text
      t.text :actions
      t.attachment :cover
      t.integer :special, default: 0
      t.integer :status, default: 0
      t.integer :kind, default: 0

      t.timestamps null: false
    end
  end
end
