class AddSpecialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :special, :integer, default: 0
  end
end
