class AddAvailaibleTpTechnicianToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :available_to_technician, :boolean, :default => false, :null => false
  end
end
