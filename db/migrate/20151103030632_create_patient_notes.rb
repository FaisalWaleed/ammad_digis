class CreatePatientNotes < ActiveRecord::Migration
  def change
    create_table :patient_notes do |t|
      t.integer :patient_id
      t.integer :patient_note_type_id
      t.text :note, limit: 4096
      t.string :author_type, limit: 40
      t.integer :author_id

      t.timestamps null: false
    end
  end
end
