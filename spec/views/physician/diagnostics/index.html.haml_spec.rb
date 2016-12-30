require 'rails_helper'

RSpec.describe "physician/diagnostics/index", type: :view do
  before(:each) do
    assign(:diagnostics, [
      Diagnostic.create!(
        :patient_id => "Patient",
        :send_to_patient => "Send To Patient",
        :laboratory_id => "Laboratory"
      ),
      Diagnostic.create!(
        :patient_id => "Patient",
        :send_to_patient => "Send To Patient",
        :laboratory_id => "Laboratory"
      )
    ])
  end

  it "renders a list of physician/diagnostics" do
    render
    assert_select "tr>td", :text => "Patient".to_s, :count => 2
    assert_select "tr>td", :text => "Send To Patient".to_s, :count => 2
    assert_select "tr>td", :text => "Laboratory".to_s, :count => 2
  end
end
