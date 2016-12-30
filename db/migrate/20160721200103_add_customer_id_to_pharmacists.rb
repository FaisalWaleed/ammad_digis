class AddCustomerIdToPharmacists < ActiveRecord::Migration
  def change
    add_column :pharmacists, :customer_id, :string, limit: 255
  end
end
