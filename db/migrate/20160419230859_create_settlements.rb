class CreateSettlements < ActiveRecord::Migration
  def change
    create_table :settlements do |t|
      t.integer :invoice_id
      t.integer :payment_id

      t.timestamps null: false
    end
  end
end
