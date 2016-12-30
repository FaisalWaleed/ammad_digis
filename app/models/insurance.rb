class Insurance < ActiveRecord::Base
  belongs_to :insurable, :polymorphic => true
  belongs_to :insurer
end
