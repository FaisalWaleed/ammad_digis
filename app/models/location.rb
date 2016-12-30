class Location < ActiveRecord::Base
  belongs_to :asset, :polymorphic => true
  
  has_many :technicians
  
  def label
    "#{asset.name} (#{name})"
  end
end
