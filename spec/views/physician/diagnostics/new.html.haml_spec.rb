require 'rails_helper'

RSpec.describe "physician/diagnostics/new", type: :view do
  before(:each) do
    assign(:physician_diagnostic, Diagnostic.new(
      :patient_id => "MyString",
      :send_to_patient => "MyString",
      :laboratory_id => "MyString"
    ))
  end

  it "renders new physician_diagnostic form" do
    render

    assert_select "form[action=?][method=?]", diagnostics_path, "post" do

      assert_select "input#physician_diagnostic_patient_id[name=?]", "physician_diagnostic[patient_id]"

      assert_select "input#physician_diagnostic_send_to_patient[name=?]", "physician_diagnostic[send_to_patient]"

      assert_select "input#physician_diagnostic_laboratory_id[name=?]", "physician_diagnostic[laboratory_id]"
    end
  end
end
