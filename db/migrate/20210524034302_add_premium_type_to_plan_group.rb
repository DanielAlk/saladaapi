class AddPremiumTypeToPlanGroup < ActiveRecord::Migration
  def change
    add_column :plan_groups, :premium_type, :integer, default: 0
  end
end
