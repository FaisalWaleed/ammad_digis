require 'rails_helper'

RSpec.describe "admin/technicians/edit", type: :view do
  before(:each) do
    @admin_technician = assign(:admin_technician, Technician.create!(
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
      :admin => "MyString",
      :avatar => "MyString",
      :password => "MyString",
      :password_confirmation => "MyString",
      :login => "MyString"
    ))
  end

  it "renders the edit admin_technician form" do
    render

    assert_select "form[action=?][method=?]", admin_technician_path(@admin_technician), "post" do

      assert_select "input#admin_technician_firstname[name=?]", "admin_technician[firstname]"

      assert_select "input#admin_technician_middlename[name=?]", "admin_technician[middlename]"

      assert_select "input#admin_technician_lastname[name=?]", "admin_technician[lastname]"

      assert_select "input#admin_technician_gender_id[name=?]", "admin_technician[gender_id]"

      assert_select "input#admin_technician_date_of_birth[name=?]", "admin_technician[date_of_birth]"

      assert_select "input#admin_technician_address_street_1[name=?]", "admin_technician[address_street_1]"

      assert_select "input#admin_technician_address_street_2[name=?]", "admin_technician[address_street_2]"

      assert_select "input#admin_technician_address_municipality[name=?]", "admin_technician[address_municipality]"

      assert_select "input#admin_technician_address_territory[name=?]", "admin_technician[address_territory]"

      assert_select "input#admin_technician_address_postal_code[name=?]", "admin_technician[address_postal_code]"

      assert_select "input#admin_technician_address_country[name=?]", "admin_technician[address_country]"

      assert_select "input#admin_technician_email_primary[name=?]", "admin_technician[email_primary]"

      assert_select "input#admin_technician_email_secondary[name=?]", "admin_technician[email_secondary]"

      assert_select "input#admin_technician_phone_primary[name=?]", "admin_technician[phone_primary]"

      assert_select "input#admin_technician_phone_secondary[name=?]", "admin_technician[phone_secondary]"

      assert_select "input#admin_technician_phone_mobile[name=?]", "admin_technician[phone_mobile]"

      assert_select "input#admin_technician_phone_alternate[name=?]", "admin_technician[phone_alternate]"

      assert_select "input#admin_technician_reg_num[name=?]", "admin_technician[reg_num]"

      assert_select "input#admin_technician_active[name=?]", "admin_technician[active]"

      assert_select "input#admin_technician_admin[name=?]", "admin_technician[admin]"

      assert_select "input#admin_technician_avatar[name=?]", "admin_technician[avatar]"

      assert_select "input#admin_technician_password[name=?]", "admin_technician[password]"

      assert_select "input#admin_technician_password_confirmation[name=?]", "admin_technician[password_confirmation]"

      assert_select "input#admin_technician_login[name=?]", "admin_technician[login]"
    end
  end
end
