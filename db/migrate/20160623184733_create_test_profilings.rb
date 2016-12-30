class CreateTestProfilings < ActiveRecord::Migration
  def change
    create_table :test_profilings do |t|
      t.integer :test_profile_id
      t.integer :test_id

      t.timestamps null: false
    end
  end
end
