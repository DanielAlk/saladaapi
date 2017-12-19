class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :mercadopago_invoice_id
      t.string :mercadopago_subscription_id
      t.string :mercadopago_plan_id
      t.references :subscription
      t.references :plan
      t.references :user
      t.text :payer
      t.float :application_fee
      t.integer :status
      t.string :description
      t.text :metadata
      t.text :payments
      t.datetime :debit_date
      t.datetime :next_payment_attempt
      t.text :mercadopago_invoice

      t.timestamps null: false
    end
    add_index :invoices, :mercadopago_invoice_id
  end
end
