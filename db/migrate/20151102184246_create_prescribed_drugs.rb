class CreatePrescribedDrugs < ActiveRecord::Migration
  def change
    create_table :prescribed_drugs do |t|
      t.integer :patient_id
      t.integer :common_drug_id
      t.boolean :current, :default => false, :null => false

      t.timestamps null: false
    end
  end
end
