class CreateDrOfficeAdministrations < ActiveRecord::Migration
  def change
    create_table :dr_office_administrations do |t|
      t.integer :dr_office_id
      t.integer :admin_id

      t.timestamps null: false
    end

    add_index :dr_office_administrations, [ :dr_office_id, :admin_id ]
  end
end
