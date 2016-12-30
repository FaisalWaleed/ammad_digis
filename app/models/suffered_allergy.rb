class SufferedAllergy < ActiveRecord::Base
  belongs_to :patient
  belongs_to :common_allergy
end
