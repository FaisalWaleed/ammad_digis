class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, limit: 40, :null => false
      t.text :description, limit: 1024
      t.boolean :available_to_physician, :default => false, :null => false
      t.boolean :available_to_pharmacy, :default => false, :null => false
      t.boolean :available_to_patient, :default => false, :null => false
      t.decimal :price, precision: 8, scale: 2
      t.integer :subscription_period_amount
      t.string :subscription_period_unit, limit: 10
      t.integer :trial_period_amount
      t.string :trial_period_unit, limit: 10
      t.integer :grace_period_amount
      t.string :grace_period_unit, limit: 10
      t.boolean :renew_notify, :default => false, :null => false
      t.boolean :auto_renew, :default => false, :null => false
      t.boolean :published, :default => false, :null => false

      t.timestamps null: false
    end
  end
end
