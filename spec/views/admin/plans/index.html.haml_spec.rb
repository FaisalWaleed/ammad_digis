require 'rails_helper'

RSpec.describe "admin/plans/index", type: :view do
  before(:each) do
    assign(:plans, [
      Plan.create!(
        :name => "Name",
        :description => "Description",
        :available_to_physician => "Available To Physician",
        :available_to_pharmacy => "Available To Pharmacy",
        :available_to_patient => "Available To Patient",
        :price => "Price",
        :subscription_period_amount => "Subscription Period Amount",
        :subscription_period_unit => "Subscription Period Unit",
        :grace_period_amount => "Grace Period Amount",
        :grace_period_unit => "Grace Period Unit",
        :trial_period_amount => "Trial Period Amount",
        :trial_period_unit => "Trial Period Unit",
        :renew_notify => "Renew Notify",
        :auto_renew => "Auto Renew"
      ),
      Plan.create!(
        :name => "Name",
        :description => "Description",
        :available_to_physician => "Available To Physician",
        :available_to_pharmacy => "Available To Pharmacy",
        :available_to_patient => "Available To Patient",
        :price => "Price",
        :subscription_period_amount => "Subscription Period Amount",
        :subscription_period_unit => "Subscription Period Unit",
        :grace_period_amount => "Grace Period Amount",
        :grace_period_unit => "Grace Period Unit",
        :trial_period_amount => "Trial Period Amount",
        :trial_period_unit => "Trial Period Unit",
        :renew_notify => "Renew Notify",
        :auto_renew => "Auto Renew"
      )
    ])
  end

  it "renders a list of admin/plans" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Available To Physician".to_s, :count => 2
    assert_select "tr>td", :text => "Available To Pharmacy".to_s, :count => 2
    assert_select "tr>td", :text => "Available To Patient".to_s, :count => 2
    assert_select "tr>td", :text => "Price".to_s, :count => 2
    assert_select "tr>td", :text => "Subscription Period Amount".to_s, :count => 2
    assert_select "tr>td", :text => "Subscription Period Unit".to_s, :count => 2
    assert_select "tr>td", :text => "Grace Period Amount".to_s, :count => 2
    assert_select "tr>td", :text => "Grace Period Unit".to_s, :count => 2
    assert_select "tr>td", :text => "Trial Period Amount".to_s, :count => 2
    assert_select "tr>td", :text => "Trial Period Unit".to_s, :count => 2
    assert_select "tr>td", :text => "Renew Notify".to_s, :count => 2
    assert_select "tr>td", :text => "Auto Renew".to_s, :count => 2
  end
end
