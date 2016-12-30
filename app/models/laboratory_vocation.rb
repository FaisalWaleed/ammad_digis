class LaboratoryVocation < ActiveRecord::Base
  belongs_to :technician
  belongs_to :laboratory
end
