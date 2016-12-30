class CreateTestTaggings < ActiveRecord::Migration
  def change
    create_table :test_taggings do |t|
      t.integer :test_id
      t.integer :test_tag_id

      t.timestamps null: false
    end
  end
end
