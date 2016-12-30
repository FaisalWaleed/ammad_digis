class TestTagging < ActiveRecord::Base
  belongs_to :test_tag
  belongs_to :test
end
