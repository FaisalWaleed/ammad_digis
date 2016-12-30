class DrugFormat < ActiveRecord::Base
  has_many :quantifications
  has_many :dosage_units, :through => :quantifications
  has_many :drugs
  
  accepts_nested_attributes_for :quantifications, :allow_destroy => true
end
