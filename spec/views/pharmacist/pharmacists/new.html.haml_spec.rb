require 'rails_helper'

RSpec.describe "pharmacist/pharmacists/new", type: :view do
  before(:each) do
    assign(:pharmacist_pharmacist, Pharmacist.new(
      :firstname => "MyString",
      :lastname => "MyString",
      :middlename => "MyString",
      :gender_id => "MyString",
      :date_of_birth => "MyString",
      :address_street_1 => "MyString",
      :address_street_2 => "MyString",
      :address_municipality => "MyString",
      :address_territory => "MyString",
      :address_postal_code => "MyString",
      :address_country => "MyString",
      :email_primary => "MyString",
      :phone_primary => "MyString",
      :reg_num => "MyString",
      :avatar => "MyString",
      :password => "MyString",
      :password_confirmation => "MyString"
    ))
  end

  it "renders new pharmacist_pharmacist form" do
    render

    assert_select "form[action=?][method=?]", pharmacists_path, "post" do

      assert_select "input#pharmacist_pharmacist_firstname[name=?]", "pharmacist_pharmacist[firstname]"

      assert_select "input#pharmacist_pharmacist_lastname[name=?]", "pharmacist_pharmacist[lastname]"

      assert_select "input#pharmacist_pharmacist_middlename[name=?]", "pharmacist_pharmacist[middlename]"

      assert_select "input#pharmacist_pharmacist_gender_id[name=?]", "pharmacist_pharmacist[gender_id]"

      assert_select "input#pharmacist_pharmacist_date_of_birth[name=?]", "pharmacist_pharmacist[date_of_birth]"

      assert_select "input#pharmacist_pharmacist_address_street_1[name=?]", "pharmacist_pharmacist[address_street_1]"

      assert_select "input#pharmacist_pharmacist_address_street_2[name=?]", "pharmacist_pharmacist[address_street_2]"

      assert_select "input#pharmacist_pharmacist_address_municipality[name=?]", "pharmacist_pharmacist[address_municipality]"

      assert_select "input#pharmacist_pharmacist_address_territory[name=?]", "pharmacist_pharmacist[address_territory]"

      assert_select "input#pharmacist_pharmacist_address_postal_code[name=?]", "pharmacist_pharmacist[address_postal_code]"

      assert_select "input#pharmacist_pharmacist_address_country[name=?]", "pharmacist_pharmacist[address_country]"

      assert_select "input#pharmacist_pharmacist_email_primary[name=?]", "pharmacist_pharmacist[email_primary]"

      assert_select "input#pharmacist_pharmacist_phone_primary[name=?]", "pharmacist_pharmacist[phone_primary]"

      assert_select "input#pharmacist_pharmacist_reg_num[name=?]", "pharmacist_pharmacist[reg_num]"

      assert_select "input#pharmacist_pharmacist_avatar[name=?]", "pharmacist_pharmacist[avatar]"

      assert_select "input#pharmacist_pharmacist_password[name=?]", "pharmacist_pharmacist[password]"

      assert_select "input#pharmacist_pharmacist_password_confirmation[name=?]", "pharmacist_pharmacist[password_confirmation]"
    end
  end
end
