class CreatePersonalIdTypes < ActiveRecord::Migration
  def change
    create_table :personal_id_types do |t|
      t.string :name, limit: 40
      t.text :description, limit: 1024
      t.string :code, limit: 10

      t.timestamps null: false
    end
  end
end
