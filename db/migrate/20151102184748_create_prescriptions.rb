class CreatePrescriptions < ActiveRecord::Migration
  def change
    create_table :prescriptions do |t|
      t.string :identifier, limit: 40
      t.integer :patient_id
      t.integer :pharmacy_id
      t.datetime :issued_at
      t.datetime :filled_at

      t.timestamps null: false
    end
  end
end
