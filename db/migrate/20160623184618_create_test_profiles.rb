class CreateTestProfiles < ActiveRecord::Migration
  def change
    create_table :test_profiles do |t|
      t.string :name, limit: 40
      t.integer :test_type_id

      t.timestamps null: false
    end
  end
end
