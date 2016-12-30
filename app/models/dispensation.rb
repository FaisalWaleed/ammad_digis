class Dispensation < ActiveRecord::Base
  belongs_to :dispensable
  belongs_to :pharmacist
  
  has_one :pharmacy, :through => :dispensable
  has_one :prescription, :through => :dispensable
  
  after_create do
#     dispensable.prescript.increment_repeats!
  end
  
  after_destroy do
#     dispensable.prescript.decrement_repeats!
  end
end
