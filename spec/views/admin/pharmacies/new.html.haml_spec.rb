require 'rails_helper'

RSpec.describe "admin/pharmacies/new", type: :view do
  before(:each) do
    assign(:admin_pharmacy, Pharmacy.new(
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
      :phone_mobile => "MyString",
      :phone_alternate => "MyString",
      :reg_num => "MyString"
    ))
  end

  it "renders new admin_pharmacy form" do
    render

    assert_select "form[action=?][method=?]", pharmacies_path, "post" do

      assert_select "input#admin_pharmacy_contact_firstname[name=?]", "admin_pharmacy[contact_firstname]"

      assert_select "input#admin_pharmacy_contact_lastname[name=?]", "admin_pharmacy[contact_lastname]"

      assert_select "input#admin_pharmacy_address_street_1[name=?]", "admin_pharmacy[address_street_1]"

      assert_select "input#admin_pharmacy_address_street_2[name=?]", "admin_pharmacy[address_street_2]"

      assert_select "input#admin_pharmacy_address_municipality[name=?]", "admin_pharmacy[address_municipality]"

      assert_select "input#admin_pharmacy_address_territory[name=?]", "admin_pharmacy[address_territory]"

      assert_select "input#admin_pharmacy_address_postal_code[name=?]", "admin_pharmacy[address_postal_code]"

      assert_select "input#admin_pharmacy_address_country[name=?]", "admin_pharmacy[address_country]"

      assert_select "input#admin_pharmacy_latitude[name=?]", "admin_pharmacy[latitude]"

      assert_select "input#admin_pharmacy_longitude[name=?]", "admin_pharmacy[longitude]"

      assert_select "input#admin_pharmacy_email_primary[name=?]", "admin_pharmacy[email_primary]"

      assert_select "input#admin_pharmacy_email_secondary[name=?]", "admin_pharmacy[email_secondary]"

      assert_select "input#admin_pharmacy_phone_primary[name=?]", "admin_pharmacy[phone_primary]"

      assert_select "input#admin_pharmacy_phone_secondary[name=?]", "admin_pharmacy[phone_secondary]"

      assert_select "input#admin_pharmacy_phone_mobile[name=?]", "admin_pharmacy[phone_mobile]"

      assert_select "input#admin_pharmacy_phone_alternate[name=?]", "admin_pharmacy[phone_alternate]"

      assert_select "input#admin_pharmacy_reg_num[name=?]", "admin_pharmacy[reg_num]"
    end
  end
end
