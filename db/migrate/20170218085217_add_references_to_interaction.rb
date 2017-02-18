class AddReferencesToInteraction < ActiveRecord::Migration
  def change
  	add_reference :interactions, :owner, references: :users, index: true
  	add_foreign_key :interactions, :users, column: :owner_id
  	add_reference :interactions, :last_comment, references: :comments, index: true
  	add_foreign_key :interactions, :comments, column: :last_comment_id
  end
end
