class CreatePrescripts < ActiveRecord::Migration
  def change
    create_table :prescripts do |t|
      t.integer :drug_id
      t.integer :prescription_id
      t.datetime :filled_at
      t.decimal :dose, precision: 10, scale: 2
      t.integer :dosage_unit_id
      t.integer :dosage_route_id
      t.integer :dosage_frequency_id
      t.decimal :dosage_duration, precision: 6, scale: 2
      t.integer :dosage_duration_unit_id

      t.timestamps null: false
    end

    add_index :prescripts, [ :drug_id, :prescription_id ]
  end
end
