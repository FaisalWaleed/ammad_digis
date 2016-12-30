json.array!(@plans) do |plan|
  json.extract! plan, :id, :name, :description, :available_to_physician, :available_to_pharmacy, :available_to_patient, :price, :subscription_period_amount, :subscription_period_unit, :grace_period_amount, :grace_period_unit, :trial_period_amount, :trial_period_unit, :renew_notify, :auto_renew
  json.url admin_plan_url(plan, format: :json)
end
