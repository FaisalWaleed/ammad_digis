class AddDoseFilledToDispensables < ActiveRecord::Migration
  def change
    add_column :dispensables, :dose_filled, :decimal, precision: 8, scale: 2, :default => 0.0, :null => false
  end
end
