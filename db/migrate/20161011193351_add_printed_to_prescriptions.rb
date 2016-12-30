class AddPrintedToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :printed, :boolean, default: false, null: false
  end
end
