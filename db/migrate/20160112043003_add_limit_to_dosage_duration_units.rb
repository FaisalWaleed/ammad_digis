class AddLimitToDosageDurationUnits < ActiveRecord::Migration
  def change
    add_column :dosage_duration_units, :threshold, :integer, :default => 0, :null => false
  end
end
