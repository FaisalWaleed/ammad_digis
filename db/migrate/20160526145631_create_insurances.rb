class CreateInsurances < ActiveRecord::Migration
  def change
    create_table :insurances do |t|
      t.integer :insurable_id
      t.string :insurable_type
      t.integer :insurer_id

      t.timestamps null: false
    end
  end
end
