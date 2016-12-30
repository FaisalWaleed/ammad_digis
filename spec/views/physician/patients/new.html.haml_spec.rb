require 'rails_helper'

RSpec.describe "physician/patients/new", type: :view do
  before(:each) do
    assign(:physician_patient, Patient.new(
      :firstname => "MyString",
      :lastname => "MyString",
      :middlename => "MyString",
      :gender_id => "MyString",
      :date_of_birth => "MyString",
      :physician_id => "MyString",
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
      :personal_id_type_id => "MyString",
      :personal_id_code => "MyString",
      :avatar => "MyString"
    ))
  end

  it "renders new physician_patient form" do
    render

    assert_select "form[action=?][method=?]", patients_path, "post" do

      assert_select "input#physician_patient_firstname[name=?]", "physician_patient[firstname]"

      assert_select "input#physician_patient_lastname[name=?]", "physician_patient[lastname]"

      assert_select "input#physician_patient_middlename[name=?]", "physician_patient[middlename]"

      assert_select "input#physician_patient_gender_id[name=?]", "physician_patient[gender_id]"

      assert_select "input#physician_patient_date_of_birth[name=?]", "physician_patient[date_of_birth]"

      assert_select "input#physician_patient_physician_id[name=?]", "physician_patient[physician_id]"

      assert_select "input#physician_patient_address_street_1[name=?]", "physician_patient[address_street_1]"

      assert_select "input#physician_patient_address_street_2[name=?]", "physician_patient[address_street_2]"

      assert_select "input#physician_patient_address_municipality[name=?]", "physician_patient[address_municipality]"

      assert_select "input#physician_patient_address_territory[name=?]", "physician_patient[address_territory]"

      assert_select "input#physician_patient_address_postal_code[name=?]", "physician_patient[address_postal_code]"

      assert_select "input#physician_patient_address_country[name=?]", "physician_patient[address_country]"

      assert_select "input#physician_patient_email_primary[name=?]", "physician_patient[email_primary]"

      assert_select "input#physician_patient_email_secondary[name=?]", "physician_patient[email_secondary]"

      assert_select "input#physician_patient_phone_primary[name=?]", "physician_patient[phone_primary]"

      assert_select "input#physician_patient_phone_secondary[name=?]", "physician_patient[phone_secondary]"

      assert_select "input#physician_patient_phone_mobile[name=?]", "physician_patient[phone_mobile]"

      assert_select "input#physician_patient_phone_alternate[name=?]", "physician_patient[phone_alternate]"

      assert_select "input#physician_patient_personal_id_type_id[name=?]", "physician_patient[personal_id_type_id]"

      assert_select "input#physician_patient_personal_id_code[name=?]", "physician_patient[personal_id_code]"

      assert_select "input#physician_patient_avatar[name=?]", "physician_patient[avatar]"
    end
  end
end
