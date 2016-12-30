class TestProfiling < ActiveRecord::Base
  belongs_to :test_profile
  belongs_to :test
end
