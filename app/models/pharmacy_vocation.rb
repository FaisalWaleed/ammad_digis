class PharmacyVocation < ActiveRecord::Base
  belongs_to :pharmacy
  belongs_to :pharmacist
end
