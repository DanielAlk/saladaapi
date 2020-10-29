class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.text :search
      t.integer :count

      t.timestamps null: false
    end
  end
end
