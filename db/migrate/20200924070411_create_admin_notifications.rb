class CreateAdminNotifications < ActiveRecord::Migration
  def change
    create_table :admin_notifications do |t|
      t.integer :kind, default: 0
      t.references :alertable, polymorphic: true, index: true
      t.text :metadata
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
