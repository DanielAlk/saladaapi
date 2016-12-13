class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text :text
      t.references :commentable, polymorphic: true, index: true
      t.references :user, index: true, foreign_key: true
      t.integer :role, default: 0
      t.integer :status, default: 0
      t.boolean :read, default: false

      t.timestamps null: false
    end
  end
end
