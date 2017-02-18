class AddReceiverToComment < ActiveRecord::Migration
  def change
  	add_reference :comments, :receiver, references: :users, index: true
  	add_foreign_key :comments, :users, column: :receiver_id
  end
end
