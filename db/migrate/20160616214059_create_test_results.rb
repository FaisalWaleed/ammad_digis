class CreateTestResults < ActiveRecord::Migration
  def change
    create_table :test_results do |t|
      t.integer :test_id
      t.text :notes, limit: 2048

      t.timestamps null: false
    end
  end
end
