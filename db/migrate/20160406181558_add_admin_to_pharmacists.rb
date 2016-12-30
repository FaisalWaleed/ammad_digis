class AddAdminToPharmacists < ActiveRecord::Migration
  def change
    add_column :pharmacists, :admin, :boolean, :default => false, :null => false
  end
end
