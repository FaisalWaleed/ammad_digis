class CreatePatientNoteTypes < ActiveRecord::Migration
  def change
    create_table :patient_note_types do |t|
      t.string :name, limit: 40
      t.string :code, limit: 20

      t.timestamps null: false
    end
  end
end
