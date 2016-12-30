class ProfiledTesting < ActiveRecord::Base
  attr_accessor :_permit
  
  belongs_to :test
  belongs_to :diagnostic
  belongs_to :test_profile
end
