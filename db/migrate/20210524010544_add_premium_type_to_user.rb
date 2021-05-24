class AddPremiumTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :premium_type, :integer, default: 0
  end
end
