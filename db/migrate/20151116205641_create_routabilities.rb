class CreateRoutabilities < ActiveRecord::Migration
  def change
    create_table :routabilities do |t|
      t.integer :dosage_route_id
      t.integer :drug_id

      t.timestamps null: false
    end
  end
end
