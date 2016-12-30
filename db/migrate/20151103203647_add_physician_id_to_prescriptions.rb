class AddPhysicianIdToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :physician_id, :integer
  end
end
