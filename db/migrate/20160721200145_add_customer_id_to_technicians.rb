class AddCustomerIdToTechnicians < ActiveRecord::Migration
  def change
    add_column :technicians, :customer_id, :string, limit: 255
  end
end
