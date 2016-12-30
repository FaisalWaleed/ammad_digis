class AddCustomerIdToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :customer_id, :string, limit: 255
  end
end
