class AddUserRoleToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :user_role, :integer, default: 0
  end
end
