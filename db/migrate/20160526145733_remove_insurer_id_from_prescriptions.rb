class RemoveInsurerIdFromPrescriptions < ActiveRecord::Migration
  def change
    remove_column :prescriptions, :insurer_id, :integer
  end
end
