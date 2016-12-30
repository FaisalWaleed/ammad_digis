require 'rails_helper'

RSpec.describe "admin/test_profiles/new", type: :view do
  before(:each) do
    assign(:admin_test_profile, TestProfile.new(
      :name => "MyString",
      :test_type_id => "MyString"
    ))
  end

  it "renders new admin_test_profile form" do
    render

    assert_select "form[action=?][method=?]", test_profiles_path, "post" do

      assert_select "input#admin_test_profile_name[name=?]", "admin_test_profile[name]"

      assert_select "input#admin_test_profile_test_type_id[name=?]", "admin_test_profile[test_type_id]"
    end
  end
end
