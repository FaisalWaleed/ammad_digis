class CreatePhysicianSpecializations < ActiveRecord::Migration
  def change
    create_table :physician_specializations do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
