require 'rails_helper'

RSpec.describe "physician/prescriptions/index", type: :view do
  before(:each) do
    assign(:prescriptions, [
      Prescription.create!(
        :identifier => "Identifier",
        :patient_id => "Patient",
        :pharmacy_id => "Pharmacy"
      ),
      Prescription.create!(
        :identifier => "Identifier",
        :patient_id => "Patient",
        :pharmacy_id => "Pharmacy"
      )
    ])
  end

  it "renders a list of physician/prescriptions" do
    render
    assert_select "tr>td", :text => "Identifier".to_s, :count => 2
    assert_select "tr>td", :text => "Patient".to_s, :count => 2
    assert_select "tr>td", :text => "Pharmacy".to_s, :count => 2
  end
end
