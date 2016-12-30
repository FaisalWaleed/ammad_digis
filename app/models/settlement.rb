class Settlement < ActiveRecord::Base
  belongs_to :payment
  belongs_to :subscription
end
