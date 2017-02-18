class AddInteractionToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :interaction, index: true, foreign_key: true
  end
end
