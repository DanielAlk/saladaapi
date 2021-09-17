class AddIsPromotedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_promoted, :boolean, default: false
  end
end
