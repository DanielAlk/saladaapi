class ChangeIsRetailerDefaultToUser < ActiveRecord::Migration
  def up
    change_column_default :users, :is_retailer, nil
  end
  
  def down
    change_column_default :users, :is_retailer, false
  end
end
