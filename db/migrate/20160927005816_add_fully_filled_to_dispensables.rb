class AddFullyFilledToDispensables < ActiveRecord::Migration
  def change
    add_column :dispensables, :fully_filled, :boolean, default: true, null: false
  end
end
