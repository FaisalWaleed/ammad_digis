class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id
      t.string :subscriber_type
      t.integer :plan_id, :null => false
      t.datetime :expire_at, :null => false
      t.decimal :price, precision: 8, scale: 2
      t.integer :subscription_period_amount
      t.string :subscription_period_unit, limit: 10
      t.integer :trial_period_amount
      t.string :trial_period_unit, limit: 10
      t.integer :grace_period_amount
      t.string :grace_period_unit, limit: 10
      t.boolean :renew_notify, :default => false, :null => false
      t.boolean :auto_renew, :default => false, :null => false
      t.integer :coupon_id

      t.timestamps null: false
    end
  end
end
