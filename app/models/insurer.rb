class Insurer < ActiveRecord::Base
  has_many :insurances
  has_many :prescriptions, :through => :insurances, :source => :insurable, :source_type => 'Prescription'
  
end
