class CreateInsurers < ActiveRecord::Migration
  def change
    create_table :insurers do |t|
      t.string :name, limit: 255

      t.timestamps null: false
    end
  end
end
