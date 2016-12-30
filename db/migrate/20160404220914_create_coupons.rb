class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.decimal :discount, precision: 5, scale: 2
      t.string :code, limit: 20
      t.datetime :expire_at

      t.timestamps null: false
    end
  end
end
