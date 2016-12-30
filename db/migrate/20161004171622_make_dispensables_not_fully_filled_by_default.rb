class MakeDispensablesNotFullyFilledByDefault < ActiveRecord::Migration
  def change
    change_column :dispensables, :fully_filled, :boolean, :default => false, :null => false
  end
end
