class CreateDrOfficeVocations < ActiveRecord::Migration
  def change
    create_table :dr_office_vocations do |t|
      t.integer :dr_office_id
      t.integer :physician_id
      t.boolean :primary, :default => false, :null => false
      t.date    :begin_on
      t.date    :end_on
      
      t.timestamps null: false
    end

    add_index :dr_office_vocations, [ :dr_office_id, :physician_id ]
  end
end
