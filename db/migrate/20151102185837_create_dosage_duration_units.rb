class CreateDosageDurationUnits < ActiveRecord::Migration
  def change
    create_table :dosage_duration_units do |t|
      t.string :name, limit: 20
      t.string :code, limit: 10

      t.timestamps null: false
    end
  end
end
