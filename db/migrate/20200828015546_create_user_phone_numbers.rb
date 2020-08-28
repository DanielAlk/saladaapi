class CreateUserPhoneNumbers < ActiveRecord::Migration
  def change
    create_table :user_phone_numbers do |t|
      t.references :user
      t.string :phone_number

      t.timestamps null: false
    end
  end
end
