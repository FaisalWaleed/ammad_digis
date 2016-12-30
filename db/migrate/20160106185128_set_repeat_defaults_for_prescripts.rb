class SetRepeatDefaultsForPrescripts < ActiveRecord::Migration
  def change
    change_column :prescripts, :repeat_max, :integer, :default => 0, :null => false
    change_column :prescripts, :repeat_count, :integer, :default => 0, :null => false
  end
end
