class CreateConsults < ActiveRecord::Migration
  def change
    create_table :consults do |t|
      t.integer :patient_id
      t.integer :physician_id

      t.timestamps null: false
    end

    add_index :consults, [ :patient_id, :physician_id ]
  end
end
