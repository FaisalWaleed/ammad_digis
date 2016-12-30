class Coupon < ActiveRecord::Base
  has_one :subscription
  
  scope :expired, -> { where('coupons.expire_at < ?', Time.now.to_date) }
  scope :valid, -> { where('coupons.expire_at > ? OR expire_at IS NULL', Time.now.to_date) }
  
  def expired?
    expire_at < Time.now.to_date
  end
end
