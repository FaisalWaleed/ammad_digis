class CreatePharmacyVocations < ActiveRecord::Migration
  def change
    create_table :pharmacy_vocations do |t|
      t.integer :pharmacy_id
      t.integer :pharmacist_id
      t.boolean :primary, :default => false, :null => false
      t.date    :begin_on
      t.date    :end_on

      t.timestamps null: false
    end

    add_index :pharmacy_vocations, [ :pharmacy_id, :pharmacist_id ]
  end
end
