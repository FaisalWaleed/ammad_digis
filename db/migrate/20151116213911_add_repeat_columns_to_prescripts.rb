class AddRepeatColumnsToPrescripts < ActiveRecord::Migration
  def change
    add_column :prescripts, :repeat_max, :integer, :default => 0, :null => false
    add_column :prescripts, :repeat_count, :integer, :default => 0, :null => false
  end
end
