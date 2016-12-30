class Disbursement < ActiveRecord::Base
  belongs_to :dispensable
  belongs_to :pharmacist
  belongs_to :pharmacy
  
  has_one :physician, :through => :dispensable
  has_one :prescript, :through => :dispensable
  has_one :prescription, :through => :prescript
  has_one :patient, :through => :prescript
  
  delegate :name, :to => :pharmacist, :prefix => true, :allow_nil => true
  delegate :name, :to => :pharmacy, :prefix => true, :allow_nil => true
end
