class CreateCommonAllergies < ActiveRecord::Migration
  def change
    create_table :common_allergies do |t|
      t.string :name, limit: 40
      t.text :description, limit: 1024
      t.text :aliases, limit: 1024

      t.timestamps null: false
    end
  end
end
