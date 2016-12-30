class AddAllowGenericToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :allow_generic, :boolean, :default => false, :null => false
  end
end
