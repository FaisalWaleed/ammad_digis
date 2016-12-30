class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer :physician_id
      t.integer :patient_id
      t.timestamps null: false
    end
  end
end
