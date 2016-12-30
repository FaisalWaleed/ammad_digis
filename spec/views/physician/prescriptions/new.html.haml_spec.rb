require 'rails_helper'

RSpec.describe "physician/prescriptions/new", type: :view do
  before(:each) do
    assign(:physician_prescription, Prescription.new(
      :identifier => "MyString",
      :patient_id => "MyString",
      :pharmacy_id => "MyString"
    ))
  end

  it "renders new physician_prescription form" do
    render

    assert_select "form[action=?][method=?]", prescriptions_path, "post" do

      assert_select "input#physician_prescription_identifier[name=?]", "physician_prescription[identifier]"

      assert_select "input#physician_prescription_patient_id[name=?]", "physician_prescription[patient_id]"

      assert_select "input#physician_prescription_pharmacy_id[name=?]", "physician_prescription[pharmacy_id]"
    end
  end
end
