class CreateAppConfigs < ActiveRecord::Migration
  def change
    create_table :app_configs do |t|
      t.string :sid
      t.string :title
      t.text :content

      t.timestamps null: false
    end
    add_index :app_configs, :sid
  end
end
