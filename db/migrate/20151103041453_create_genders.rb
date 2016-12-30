class CreateGenders < ActiveRecord::Migration
  def change
    create_table :genders do |t|
      t.string :name, limit: 40

      t.timestamps null: false
    end
  end
end
