class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name, limit: 40
      t.integer :test_type_id

      t.timestamps null: false
    end
  end
end
