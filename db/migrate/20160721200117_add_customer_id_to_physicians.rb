class AddCustomerIdToPhysicians < ActiveRecord::Migration
  def change
    add_column :physicians, :customer_id, :string, limit: 255
  end
end
