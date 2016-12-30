class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.decimal :total, precision: 8, scale: 1, :default => 0.0, :null => false
      t.date :due_on
      t.integer :customer_id
      t.string :customer_type, limit: 40

      t.timestamps null: false
    end
  end
end
