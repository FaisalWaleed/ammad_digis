require 'rails_helper'

RSpec.describe "admin/plans/show", type: :view do
  before(:each) do
    @admin_plan = assign(:admin_plan, Plan.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Available To Physician/)
    expect(rendered).to match(/Available To Pharmacy/)
    expect(rendered).to match(/Available To Patient/)
    expect(rendered).to match(/Price/)
    expect(rendered).to match(/Subscription Period Amount/)
    expect(rendered).to match(/Subscription Period Unit/)
    expect(rendered).to match(/Grace Period Amount/)
    expect(rendered).to match(/Grace Period Unit/)
    expect(rendered).to match(/Trial Period Amount/)
    expect(rendered).to match(/Trial Period Unit/)
    expect(rendered).to match(/Renew Notify/)
    expect(rendered).to match(/Auto Renew/)
  end
end
