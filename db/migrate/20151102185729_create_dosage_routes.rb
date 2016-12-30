class CreateDosageRoutes < ActiveRecord::Migration
  def change
    create_table :dosage_routes do |t|
      t.string :name, limit: 40
      t.string :code, limit: 20

      t.timestamps null: false
    end
  end
end
