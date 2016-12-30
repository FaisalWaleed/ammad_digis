class CreateProfiledTestings < ActiveRecord::Migration
  def change
    create_table :profiled_testings do |t|
      t.integer :test_id
      t.integer :diagnostic_id
      t.integer :test_profile_id
      t.boolean :completed, :default => false, :null => false

      t.timestamps null: false
    end
  end
end
