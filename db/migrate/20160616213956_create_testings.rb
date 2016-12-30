class CreateTestings < ActiveRecord::Migration
  def change
    create_table :testings do |t|
      t.integer :test_id
      t.integer :diagnostic_id

      t.timestamps null: false
    end
  end
end
