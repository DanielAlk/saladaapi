class AddMinimumAmountToProduct < ActiveRecord::Migration
  def change
    add_column :products, :minimum_amount, :integer
  end
end
