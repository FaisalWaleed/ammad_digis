class LaboratoryTestType < ActiveRecord::Base
  belongs_to :laboratory
  belongs_to :test_type
end
