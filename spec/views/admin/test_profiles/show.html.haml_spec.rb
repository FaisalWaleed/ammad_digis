require 'rails_helper'

RSpec.describe "admin/test_profiles/show", type: :view do
  before(:each) do
    @admin_test_profile = assign(:admin_test_profile, TestProfile.create!(
      :name => "Name",
      :test_type_id => "Test Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Test Type/)
  end
end
