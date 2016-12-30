class CreateDrOffices < ActiveRecord::Migration
  def change
    create_table :dr_offices do |t|
      t.string :name, limit: 40
      t.string :address_street_1, limit: 255
      t.string :address_street_2, limit: 255
      t.string :address_municipality, limit: 80
      t.string :address_territory, limit: 80
      t.string :address_postal_code, limit: 10
      t.string :address_country, limit: 40
      t.decimal :latitude, :precision => 16, :scale => 12
      t.decimal :longitude, :precision => 16, :scale => 12
      t.string :email_primary, limit: 80
      t.string :email_secondary, limit: 80
      t.string :phone_primary, limit: 40
      t.string :phone_secondary, limit: 40
      t.string :phone_mobile, limit: 40
      t.string :phone_alternate, limit: 40
      t.string :reg_num, limit: 40

      t.timestamps null: false
    end

    add_index :dr_offices, :name
  end
end
