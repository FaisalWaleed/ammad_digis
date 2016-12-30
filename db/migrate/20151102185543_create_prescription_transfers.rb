class CreatePrescriptionTransfers < ActiveRecord::Migration
  def change
    create_table :prescription_transfers do |t|
      t.integer :prescription_id
      t.integer :transferer_id
      t.integer :transferee_id

      t.timestamps null: false
    end
  end
end
