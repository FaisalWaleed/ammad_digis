class MakePharmacistsAndPhysiciansInactiveByDefault < ActiveRecord::Migration
  def up
    change_column :pharmacists, :active, :boolean, :default => false, :null => false
    change_column :physicians, :active, :boolean, :default => false, :null => false
  end
  def down
    change_column :pharmacists, :active, :boolean, :default => true, :null => false
    change_column :physicians, :active, :boolean, :default => true, :null => false
  end
end
