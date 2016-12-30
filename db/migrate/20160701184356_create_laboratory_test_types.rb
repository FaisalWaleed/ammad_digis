class CreateLaboratoryTestTypes < ActiveRecord::Migration
  def change
    create_table :laboratory_test_types do |t|
      t.integer :laboratory_id
      t.integer :test_type_id

      t.timestamps null: false
    end
  end
end
