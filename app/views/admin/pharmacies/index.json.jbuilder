json.array!(@pharmacies) do |pharmacy|
  json.extract! pharmacy, :id, :contact_firstname, :contact_lastname, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :latitude, :longitude, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :reg_num
  json.url pharmacy_url(pharmacy, format: :json)
end
