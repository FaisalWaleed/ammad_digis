require 'rails_helper'

RSpec.describe "admin/test_profiles/edit", type: :view do
  before(:each) do
    @admin_test_profile = assign(:admin_test_profile, TestProfile.create!(
      :name => "MyString",
      :test_type_id => "MyString"
    ))
  end

  it "renders the edit admin_test_profile form" do
    render

    assert_select "form[action=?][method=?]", admin_test_profile_path(@admin_test_profile), "post" do

      assert_select "input#admin_test_profile_name[name=?]", "admin_test_profile[name]"

      assert_select "input#admin_test_profile_test_type_id[name=?]", "admin_test_profile[test_type_id]"
    end
  end
end
