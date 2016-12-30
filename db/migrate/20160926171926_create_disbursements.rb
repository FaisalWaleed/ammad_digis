class CreateDisbursements < ActiveRecord::Migration
  def change
    create_table :disbursements do |t|
      t.integer :pharmacist_id
      t.text :annotation, limit: 1024
      t.integer :prescribed_drug_strength
      t.string :prescribed_drug_unit, limit: 10
      t.integer :filled_drug_strength
      t.string :filled_drug_unit, limit: 10
      t.integer :filled_drug_id
      t.decimal :filled_dose, precision: 6, scale: 2
      t.integer :dispensable_id

      t.timestamps null: false
    end
  end
end
