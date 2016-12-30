class Routability < ActiveRecord::Base
  belongs_to :drug
  belongs_to :dosage_route
end
