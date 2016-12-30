class AddCommentableToDispenseOrders < ActiveRecord::Migration
  def change
    add_column :dispense_orders, :commentable, :boolean, :null => false, :default => true
  end
end
