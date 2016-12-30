require 'rails_helper'

RSpec.describe "admin/pharmacists/new", type: :view do
  before(:each) do
    assign(:admin_pharmacist, Pharmacist.new(
      :firstname => "MyString",
      :middlename => "MyString",
      :lastname => "MyString",
      :gender_id => "MyString",
      :date_of_birth => "MyString",
      :address_street_1 => "MyString",
      :address_street_2 => "MyString",
      :address_municipality => "MyString",
      :address_territory => "MyString",
      :address_postal_code => "MyString",
      :address_country => "MyString",
      :email_primary => "MyString",
      :email_secondary => "MyString",
      :phone_primary => "MyString",
      :phone_secondary => "MyString",
      :phone_mobile => "MyString",
      :phone_alternate => "MyString",
      :reg_num => "MyString",
      :active => "MyString",
      :avatar => "MyString"
    ))
  end

  it "renders new admin_pharmacist form" do
    render

    assert_select "form[action=?][method=?]", pharmacists_path, "post" do

      assert_select "input#admin_pharmacist_firstname[name=?]", "admin_pharmacist[firstname]"

      assert_select "input#admin_pharmacist_middlename[name=?]", "admin_pharmacist[middlename]"

      assert_select "input#admin_pharmacist_lastname[name=?]", "admin_pharmacist[lastname]"

      assert_select "input#admin_pharmacist_gender_id[name=?]", "admin_pharmacist[gender_id]"

      assert_select "input#admin_pharmacist_date_of_birth[name=?]", "admin_pharmacist[date_of_birth]"

      assert_select "input#admin_pharmacist_address_street_1[name=?]", "admin_pharmacist[address_street_1]"

      assert_select "input#admin_pharmacist_address_street_2[name=?]", "admin_pharmacist[address_street_2]"

      assert_select "input#admin_pharmacist_address_municipality[name=?]", "admin_pharmacist[address_municipality]"

      assert_select "input#admin_pharmacist_address_territory[name=?]", "admin_pharmacist[address_territory]"

      assert_select "input#admin_pharmacist_address_postal_code[name=?]", "admin_pharmacist[address_postal_code]"

      assert_select "input#admin_pharmacist_address_country[name=?]", "admin_pharmacist[address_country]"

      assert_select "input#admin_pharmacist_email_primary[name=?]", "admin_pharmacist[email_primary]"

      assert_select "input#admin_pharmacist_email_secondary[name=?]", "admin_pharmacist[email_secondary]"

      assert_select "input#admin_pharmacist_phone_primary[name=?]", "admin_pharmacist[phone_primary]"

      assert_select "input#admin_pharmacist_phone_secondary[name=?]", "admin_pharmacist[phone_secondary]"

      assert_select "input#admin_pharmacist_phone_mobile[name=?]", "admin_pharmacist[phone_mobile]"

      assert_select "input#admin_pharmacist_phone_alternate[name=?]", "admin_pharmacist[phone_alternate]"

      assert_select "input#admin_pharmacist_reg_num[name=?]", "admin_pharmacist[reg_num]"

      assert_select "input#admin_pharmacist_active[name=?]", "admin_pharmacist[active]"

      assert_select "input#admin_pharmacist_avatar[name=?]", "admin_pharmacist[avatar]"
    end
  end
end
