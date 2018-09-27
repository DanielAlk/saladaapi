class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :subtitle
      t.text :text
      t.attachment :cover
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
