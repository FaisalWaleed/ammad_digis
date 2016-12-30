require 'rails_helper'

RSpec.describe "admin/plans/edit", type: :view do
  before(:each) do
    @admin_plan = assign(:admin_plan, Plan.create!(
      :name => "MyString",
      :description => "MyString",
      :available_to_physician => "MyString",
      :available_to_pharmacy => "MyString",
      :available_to_patient => "MyString",
      :price => "MyString",
      :subscription_period_amount => "MyString",
      :subscription_period_unit => "MyString",
      :grace_period_amount => "MyString",
      :grace_period_unit => "MyString",
      :trial_period_amount => "MyString",
      :trial_period_unit => "MyString",
      :renew_notify => "MyString",
      :auto_renew => "MyString"
    ))
  end

  it "renders the edit admin_plan form" do
    render

    assert_select "form[action=?][method=?]", admin_plan_path(@admin_plan), "post" do

      assert_select "input#admin_plan_name[name=?]", "admin_plan[name]"

      assert_select "input#admin_plan_description[name=?]", "admin_plan[description]"

      assert_select "input#admin_plan_available_to_physician[name=?]", "admin_plan[available_to_physician]"

      assert_select "input#admin_plan_available_to_pharmacy[name=?]", "admin_plan[available_to_pharmacy]"

      assert_select "input#admin_plan_available_to_patient[name=?]", "admin_plan[available_to_patient]"

      assert_select "input#admin_plan_price[name=?]", "admin_plan[price]"

      assert_select "input#admin_plan_subscription_period_amount[name=?]", "admin_plan[subscription_period_amount]"

      assert_select "input#admin_plan_subscription_period_unit[name=?]", "admin_plan[subscription_period_unit]"

      assert_select "input#admin_plan_grace_period_amount[name=?]", "admin_plan[grace_period_amount]"

      assert_select "input#admin_plan_grace_period_unit[name=?]", "admin_plan[grace_period_unit]"

      assert_select "input#admin_plan_trial_period_amount[name=?]", "admin_plan[trial_period_amount]"

      assert_select "input#admin_plan_trial_period_unit[name=?]", "admin_plan[trial_period_unit]"

      assert_select "input#admin_plan_renew_notify[name=?]", "admin_plan[renew_notify]"

      assert_select "input#admin_plan_auto_renew[name=?]", "admin_plan[auto_renew]"
    end
  end
end
