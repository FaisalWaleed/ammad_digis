class CreateTestTypes < ActiveRecord::Migration
  def change
    create_table :test_types do |t|
      t.string :name, limit: 40
      t.text :description, limit: 1024

      t.timestamps null: false
    end
  end
end
