class TestType < ActiveRecord::Base
  has_many :test_profiles
  has_many :test_tags
  has_many :tests
  
  has_many :laboratory_test_types
  has_many :laboratories, :through => :laboratory_test_types
end
