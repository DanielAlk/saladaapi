class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :payable, polymorphic: true, index: true
      t.decimal :transaction_amount, precision: 8, scale: 2
      t.text :mercadopago_preference
      t.text :payment_info
      t.string :init_point
      t.integer :collection_id, limit: 8
      t.string :collection_status
      t.string :collection_status_detail
      t.string :preference_id
      t.string :payment_type

      t.timestamps null: false
    end
  end
end
