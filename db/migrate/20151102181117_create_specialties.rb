class CreateSpecialties < ActiveRecord::Migration
  def change
    create_table :specialties do |t|
      t.string :name, limit: 40
      t.string :code, limit: 40

      t.timestamps null: false
    end
  end
end
