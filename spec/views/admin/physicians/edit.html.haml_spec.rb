require 'rails_helper'

RSpec.describe "admin/physicians/edit", type: :view do
  before(:each) do
    @admin_physician = assign(:admin_physician, Physician.create!(
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

  it "renders the edit admin_physician form" do
    render

    assert_select "form[action=?][method=?]", admin_physician_path(@admin_physician), "post" do

      assert_select "input#admin_physician_firstname[name=?]", "admin_physician[firstname]"

      assert_select "input#admin_physician_middlename[name=?]", "admin_physician[middlename]"

      assert_select "input#admin_physician_lastname[name=?]", "admin_physician[lastname]"

      assert_select "input#admin_physician_gender_id[name=?]", "admin_physician[gender_id]"

      assert_select "input#admin_physician_date_of_birth[name=?]", "admin_physician[date_of_birth]"

      assert_select "input#admin_physician_address_street_1[name=?]", "admin_physician[address_street_1]"

      assert_select "input#admin_physician_address_street_2[name=?]", "admin_physician[address_street_2]"

      assert_select "input#admin_physician_address_municipality[name=?]", "admin_physician[address_municipality]"

      assert_select "input#admin_physician_address_territory[name=?]", "admin_physician[address_territory]"

      assert_select "input#admin_physician_address_postal_code[name=?]", "admin_physician[address_postal_code]"

      assert_select "input#admin_physician_address_country[name=?]", "admin_physician[address_country]"

      assert_select "input#admin_physician_email_primary[name=?]", "admin_physician[email_primary]"

      assert_select "input#admin_physician_email_secondary[name=?]", "admin_physician[email_secondary]"

      assert_select "input#admin_physician_phone_primary[name=?]", "admin_physician[phone_primary]"

      assert_select "input#admin_physician_phone_secondary[name=?]", "admin_physician[phone_secondary]"

      assert_select "input#admin_physician_phone_mobile[name=?]", "admin_physician[phone_mobile]"

      assert_select "input#admin_physician_phone_alternate[name=?]", "admin_physician[phone_alternate]"

      assert_select "input#admin_physician_reg_num[name=?]", "admin_physician[reg_num]"

      assert_select "input#admin_physician_active[name=?]", "admin_physician[active]"

      assert_select "input#admin_physician_avatar[name=?]", "admin_physician[avatar]"
    end
  end
end
