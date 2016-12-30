class CreateDiagnostics < ActiveRecord::Migration
  def change
    create_table :diagnostics do |t|
      t.integer :patient_id
      t.boolean :send_to_patient, :default => false, :null => false
      t.string :verification_pin
      t.integer :laboratory_id

      t.timestamps null: false
    end
  end
end
