class AddInsurerIdToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :insurer_id, :integer
  end
end
