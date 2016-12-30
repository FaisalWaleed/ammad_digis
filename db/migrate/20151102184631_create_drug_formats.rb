class CreateDrugFormats < ActiveRecord::Migration
  def change
    create_table :drug_formats do |t|
      t.string :name, limit: 40
      t.string :abbrev, limit: 20

      t.timestamps null: false
    end
  end
end
