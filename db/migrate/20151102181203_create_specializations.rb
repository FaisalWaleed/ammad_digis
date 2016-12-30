class CreateSpecializations < ActiveRecord::Migration
  def change
    create_table :specializations do |t|
      t.integer :specialty_id
      t.integer :physician_id

      t.timestamps null: false
    end

    add_index :specializations, [ :specialty_id, :physician_id ]
  end
end
