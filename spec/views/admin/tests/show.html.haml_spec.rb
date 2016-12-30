require 'rails_helper'

RSpec.describe "admin/tests/show", type: :view do
  before(:each) do
    @admin_test = assign(:admin_test, Test.create!(
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
