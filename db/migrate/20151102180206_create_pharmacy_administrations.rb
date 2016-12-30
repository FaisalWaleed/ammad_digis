class CreatePharmacyAdministrations < ActiveRecord::Migration
  def change
    create_table :pharmacy_administrations do |t|
      t.integer :pharmacy_id
      t.integer :admin_id

      t.timestamps null: false
    end

    add_index :pharmacy_administrations, [ :pharmacy_id, :admin_id ]
  end
end
