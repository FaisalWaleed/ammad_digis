require 'rails_helper'

RSpec.describe "admin/patients/edit", type: :view do
  before(:each) do
    @admin_patient = assign(:admin_patient, Patient.create!(
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

  it "renders the edit admin_patient form" do
    render

    assert_select "form[action=?][method=?]", admin_patient_path(@admin_patient), "post" do

      assert_select "input#admin_patient_firstname[name=?]", "admin_patient[firstname]"

      assert_select "input#admin_patient_middlename[name=?]", "admin_patient[middlename]"

      assert_select "input#admin_patient_lastname[name=?]", "admin_patient[lastname]"

      assert_select "input#admin_patient_gender_id[name=?]", "admin_patient[gender_id]"

      assert_select "input#admin_patient_date_of_birth[name=?]", "admin_patient[date_of_birth]"

      assert_select "input#admin_patient_address_street_1[name=?]", "admin_patient[address_street_1]"

      assert_select "input#admin_patient_address_street_2[name=?]", "admin_patient[address_street_2]"

      assert_select "input#admin_patient_address_municipality[name=?]", "admin_patient[address_municipality]"

      assert_select "input#admin_patient_address_territory[name=?]", "admin_patient[address_territory]"

      assert_select "input#admin_patient_address_postal_code[name=?]", "admin_patient[address_postal_code]"

      assert_select "input#admin_patient_address_country[name=?]", "admin_patient[address_country]"

      assert_select "input#admin_patient_email_primary[name=?]", "admin_patient[email_primary]"

      assert_select "input#admin_patient_email_secondary[name=?]", "admin_patient[email_secondary]"

      assert_select "input#admin_patient_phone_primary[name=?]", "admin_patient[phone_primary]"

      assert_select "input#admin_patient_phone_secondary[name=?]", "admin_patient[phone_secondary]"

      assert_select "input#admin_patient_phone_mobile[name=?]", "admin_patient[phone_mobile]"

      assert_select "input#admin_patient_phone_alternate[name=?]", "admin_patient[phone_alternate]"

      assert_select "input#admin_patient_reg_num[name=?]", "admin_patient[reg_num]"

      assert_select "input#admin_patient_active[name=?]", "admin_patient[active]"

      assert_select "input#admin_patient_avatar[name=?]", "admin_patient[avatar]"
    end
  end
end
