class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 8, scale: 2, :default => 0.0, :null => false
      t.datetime :paid_at
      t.integer :customer_id, :null => false
      t.string :customer_type, limit: 40, :null => false
      t.boolean :method_cc, :default => false, :null => false
      t.boolean :method_ac, :default => false, :null => false
      t.boolean :method_vc, :default => false, :null => false
      t.string :method_type, limit: 40
      t.string :method_currency, limit: 8
      t.string :merchant_response_order_id
      t.string :merchant_response_message
      t.string :merchant_response_status
      t.string :merchant_response_receiptcc
      t.string :merchant_response_auth_code
      t.text :note, limit: 4096
      t.string :payer_name, limit: 100, :null => false
      t.string :payer_email, limit: 255
      t.string :payer_phone, limit: 40
      t.string :payer_address_street_1, limit: 100
      t.string :payer_address_street_2, limit: 100
      t.string :payer_address_city, limit: 100
      t.string :payer_address_state, limit: 100
      t.string :payer_address_country, limit: 40

      t.timestamps null: false
    end
  end
end
