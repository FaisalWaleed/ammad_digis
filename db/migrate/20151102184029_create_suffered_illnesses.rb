class CreateSufferedIllnesses < ActiveRecord::Migration
  def change
    create_table :suffered_illnesses do |t|
      t.integer :patient_id
      t.integer :common_illness_id
      t.boolean :current, :default => false, :null => false

      t.timestamps null: false
    end
  end
end
