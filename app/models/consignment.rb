class Consignment < ActiveRecord::Base
  belongs_to :dispense_order
  belongs_to :dispensable
end
