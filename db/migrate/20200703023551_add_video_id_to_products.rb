class AddVideoIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :video_id, :string
  end
end
