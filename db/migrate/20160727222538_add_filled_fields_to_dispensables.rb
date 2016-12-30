class AddFilledFieldsToDispensables < ActiveRecord::Migration
  def change
    add_column :dispensables, :drug_filled, :string, limit: 255
    add_column :dispensables, :strength_filled, :string, limit: 255
  end
end
