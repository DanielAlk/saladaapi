class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :mercadopago_subscription_id
      t.string :mercadopago_plan_id
      t.references :plan
      t.references :user
      t.integer :kind
      t.text :payer
      t.string :payment_method_id
      t.string :token
      t.float :application_fee
      t.integer :status
      t.string :description
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :next_payment_date
      t.text :metadata
      t.text :charges_detail
      t.float :setup_fee
      t.text :mercadopago_subscription

      t.timestamps null: false
    end
    add_index :subscriptions, :mercadopago_subscription_id
  end
end
