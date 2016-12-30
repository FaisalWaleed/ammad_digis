require 'rails_helper'

RSpec.describe "physician/diagnostics/show", type: :view do
  before(:each) do
    @physician_diagnostic = assign(:physician_diagnostic, Diagnostic.create!(
      :patient_id => "Patient",
      :send_to_patient => "Send To Patient",
      :laboratory_id => "Laboratory"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Patient/)
    expect(rendered).to match(/Send To Patient/)
    expect(rendered).to match(/Laboratory/)
  end
end
