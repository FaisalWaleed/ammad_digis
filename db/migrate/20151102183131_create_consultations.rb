class CreateConsultations < ActiveRecord::Migration
  def change
    create_table :consultations do |t|
      t.integer :physician_id
      t.integer :consult_id

      t.timestamps null: false
    end

    add_index :consultations, [ :physician_id, :consult_id ]
  end
end
