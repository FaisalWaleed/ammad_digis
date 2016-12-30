require 'rails_helper'

RSpec.describe "physician/prescriptions/show", type: :view do
  before(:each) do
    @physician_prescription = assign(:physician_prescription, Prescription.create!(
      :identifier => "Identifier",
      :patient_id => "Patient",
      :pharmacy_id => "Pharmacy"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Identifier/)
    expect(rendered).to match(/Patient/)
    expect(rendered).to match(/Pharmacy/)
  end
end
