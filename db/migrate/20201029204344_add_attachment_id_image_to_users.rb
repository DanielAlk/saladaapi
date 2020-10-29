class AddAttachmentIdImageToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :id_image
    end
  end

  def self.down
    remove_attachment :users, :id_image
  end
end
