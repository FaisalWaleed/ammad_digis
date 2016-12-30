require 'rails_helper'

RSpec.describe "admin/laboratories/edit", type: :view do
  before(:each) do
    @admin_laboratory = assign(:admin_laboratory, Laboratory.create!(
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
      :phone_mobile => "MyString",
      :phone_alternate => "MyString",
      :reg_num => "MyString"
    ))
  end

  it "renders the edit admin_laboratory form" do
    render

    assert_select "form[action=?][method=?]", admin_laboratory_path(@admin_laboratory), "post" do

      assert_select "input#admin_laboratory_name[name=?]", "admin_laboratory[name]"

      assert_select "input#admin_laboratory_contact_firstname[name=?]", "admin_laboratory[contact_firstname]"

      assert_select "input#admin_laboratory_contact_lastname[name=?]", "admin_laboratory[contact_lastname]"

      assert_select "input#admin_laboratory_address_street_1[name=?]", "admin_laboratory[address_street_1]"

      assert_select "input#admin_laboratory_address_street_2[name=?]", "admin_laboratory[address_street_2]"

      assert_select "input#admin_laboratory_address_municipality[name=?]", "admin_laboratory[address_municipality]"

      assert_select "input#admin_laboratory_address_territory[name=?]", "admin_laboratory[address_territory]"

      assert_select "input#admin_laboratory_address_postal_code[name=?]", "admin_laboratory[address_postal_code]"

      assert_select "input#admin_laboratory_address_country[name=?]", "admin_laboratory[address_country]"

      assert_select "input#admin_laboratory_latitude[name=?]", "admin_laboratory[latitude]"

      assert_select "input#admin_laboratory_longitude[name=?]", "admin_laboratory[longitude]"

      assert_select "input#admin_laboratory_email_primary[name=?]", "admin_laboratory[email_primary]"

      assert_select "input#admin_laboratory_email_secondary[name=?]", "admin_laboratory[email_secondary]"

      assert_select "input#admin_laboratory_phone_primary[name=?]", "admin_laboratory[phone_primary]"

      assert_select "input#admin_laboratory_phone_secondary[name=?]", "admin_laboratory[phone_secondary]"

      assert_select "input#admin_laboratory_phone_mobile[name=?]", "admin_laboratory[phone_mobile]"

      assert_select "input#admin_laboratory_phone_alternate[name=?]", "admin_laboratory[phone_alternate]"

      assert_select "input#admin_laboratory_reg_num[name=?]", "admin_laboratory[reg_num]"
    end
  end
end
