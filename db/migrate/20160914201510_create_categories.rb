class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.string :ancestry

      t.timestamps null: false
    end
    add_index :categories, :ancestry
  end
end
