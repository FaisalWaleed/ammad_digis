class CreateLaboratoryVocations < ActiveRecord::Migration
  def change
    create_table :laboratory_vocations do |t|
      t.integer :laboratory_id
      t.integer :technician_id
      t.boolean :primary, :default => false, :null => false
      t.date :begin_on
      t.date :end_on

      t.timestamps null: false
    end
  end
end
