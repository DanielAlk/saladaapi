class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :tel
      t.text :message
      t.integer :role
      t.integer :subject, default: 0
      t.boolean :read, default: false

      t.timestamps null: false
    end
  end
end
