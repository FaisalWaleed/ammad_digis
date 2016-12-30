class ExtendLengthOfSpecialtyName < ActiveRecord::Migration
  def up
    change_column :specialties, :name, :text, :limit => 255
  end

  def down
    change_column :specialties, :name, :text, :limit => 40
  end
end
