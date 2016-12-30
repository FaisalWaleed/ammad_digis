class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :asset_type, limit: 40
      t.integer :asset_id
      t.string :address_street_1, limit: 255
      t.string :address_street_2, limit: 255
      t.string :address_municipality, limit: 255
      t.string :address_territory, limit: 255
      t.string :address_postal_code, limit: 40
      t.string :address_country, limit: 40
      t.decimal :latitude, precision: 16, scale: 14
      t.decimal :longitude, precision: 16, scale: 14
      t.string :email_primary, limit: 255
      t.string :email_secondary, limit: 255
      t.string :phone_primary, limit: 40
      t.string :phone_secondary, limit: 40
      t.string :fax_primary, limit: 40
      t.string :fax_secondary, limit: 40
      t.string :name, limit: 255

      t.timestamps null: false
    end
  end
end
