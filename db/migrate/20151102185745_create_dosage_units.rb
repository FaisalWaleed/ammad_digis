class CreateDosageUnits < ActiveRecord::Migration
  def change
    create_table :dosage_units do |t|
      t.string :name, limit: 40
      t.string :symbol, limit: 20

      t.timestamps null: false
    end
  end
end
