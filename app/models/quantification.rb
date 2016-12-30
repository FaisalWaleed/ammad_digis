class Quantification < ActiveRecord::Base
  belongs_to :drug_format
  belongs_to :dosage_unit
end
