class ChangeRatingTypeOnProducts < ActiveRecord::Migration
  def up
    change_column :products, :rating, :decimal, precision: 2, scale: 1
  end

  def down
    change_column :products, :rating, :integer
  end
end
