class CreateInvoiceLineItems < ActiveRecord::Migration
  def change
    create_table :invoice_line_items do |t|
      t.integer :invoice_id
      t.integer :unit_count, :default => 1, :null => false
      t.decimal :unit_price, precision: 8, scale: 2, :default => 0.0, :null => false
      t.decimal :tax, precision: 5, scale: 2, :default => 0.0, :null => false
      t.decimal :discount, precision: 5, scale: 2, :default => 0.0, :null => false
      t.decimal :subtotal, precision: 8, scale: 2, :default => 0.0, :null => false
      t.integer :asset_id, :null => false
      t.string :asset_type, limit: 40, :null => false

      t.timestamps null: false
    end
  end
end
