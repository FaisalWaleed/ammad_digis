class ExtendLengthOfDrugNameColumns < ActiveRecord::Migration
  def up
    change_column :drugs, :trade_name, :text, :limit => 255
    change_column :drugs, :generic_name, :text, :limit => 255
  end

  def down
    change_column :drugs, :trade_name, :text, :limit => 40
    change_column :drugs, :generic_name, :text, :limit => 40
  end
end
