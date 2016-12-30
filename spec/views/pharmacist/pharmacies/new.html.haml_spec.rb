require 'rails_helper'

RSpec.describe "pharmacist/pharmacies/new", type: :view do
  before(:each) do
    assign(:pharmacist_pharmacy, Pharmacy.new(
      :name => "MyString",
      :contact_firstname => "MyString",
      :contact_lastname => "MyString",
      :address_street_1 => "MyString",
      :address_street_2 => "MyString",
      :address_municipality => "MyString",
      :address_territory => "MyString",
      :address_postal_code => "MyString",
      :address_country => "MyString",
      :latitude => "MyString",
      :longitude => "MyString",
      :email_primary => "MyString",
      :email_secondary => "MyString",
      :phone_primary => "MyString",
      :phone_secondary => "MyString",
      :reg_num => "MyString"
    ))
  end

  it "renders new pharmacist_pharmacy form" do
    render

    assert_select "form[action=?][method=?]", pharmacies_path, "post" do

      assert_select "input#pharmacist_pharmacy_name[name=?]", "pharmacist_pharmacy[name]"

      assert_select "input#pharmacist_pharmacy_contact_firstname[name=?]", "pharmacist_pharmacy[contact_firstname]"

      assert_select "input#pharmacist_pharmacy_contact_lastname[name=?]", "pharmacist_pharmacy[contact_lastname]"

      assert_select "input#pharmacist_pharmacy_address_street_1[name=?]", "pharmacist_pharmacy[address_street_1]"

      assert_select "input#pharmacist_pharmacy_address_street_2[name=?]", "pharmacist_pharmacy[address_street_2]"

      assert_select "input#pharmacist_pharmacy_address_municipality[name=?]", "pharmacist_pharmacy[address_municipality]"

      assert_select "input#pharmacist_pharmacy_address_territory[name=?]", "pharmacist_pharmacy[address_territory]"

      assert_select "input#pharmacist_pharmacy_address_postal_code[name=?]", "pharmacist_pharmacy[address_postal_code]"

      assert_select "input#pharmacist_pharmacy_address_country[name=?]", "pharmacist_pharmacy[address_country]"

      assert_select "input#pharmacist_pharmacy_latitude[name=?]", "pharmacist_pharmacy[latitude]"

      assert_select "input#pharmacist_pharmacy_longitude[name=?]", "pharmacist_pharmacy[longitude]"

      assert_select "input#pharmacist_pharmacy_email_primary[name=?]", "pharmacist_pharmacy[email_primary]"

      assert_select "input#pharmacist_pharmacy_email_secondary[name=?]", "pharmacist_pharmacy[email_secondary]"

      assert_select "input#pharmacist_pharmacy_phone_primary[name=?]", "pharmacist_pharmacy[phone_primary]"

      assert_select "input#pharmacist_pharmacy_phone_secondary[name=?]", "pharmacist_pharmacy[phone_secondary]"

      assert_select "input#pharmacist_pharmacy_reg_num[name=?]", "pharmacist_pharmacy[reg_num]"
    end
  end
end
