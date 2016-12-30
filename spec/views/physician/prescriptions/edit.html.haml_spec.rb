require 'rails_helper'

RSpec.describe "physician/prescriptions/edit", type: :view do
  before(:each) do
    @physician_prescription = assign(:physician_prescription, Prescription.create!(
      :identifier => "MyString",
      :patient_id => "MyString",
      :pharmacy_id => "MyString"
    ))
  end

  it "renders the edit physician_prescription form" do
    render

    assert_select "form[action=?][method=?]", physician_prescription_path(@physician_prescription), "post" do

      assert_select "input#physician_prescription_identifier[name=?]", "physician_prescription[identifier]"

      assert_select "input#physician_prescription_patient_id[name=?]", "physician_prescription[patient_id]"

      assert_select "input#physician_prescription_pharmacy_id[name=?]", "physician_prescription[pharmacy_id]"
    end
  end
end
