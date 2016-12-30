class AddSemiFreeFlowToPrescripts < ActiveRecord::Migration
  def change
    add_column :prescripts, :semi_free_flow, :boolean, :default => false, :null => false
  end
end
