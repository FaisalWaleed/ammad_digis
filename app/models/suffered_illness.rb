class SufferedIllness < ActiveRecord::Base
  belongs_to :patient
  belongs_to :common_illness
end
