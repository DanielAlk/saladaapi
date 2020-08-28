class AddPhoneNumbersLimitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_numbers_limit, :integer, default: 0
  end
end
