class CommonIllness < ActiveRecord::Base
  has_many :suffered_illnesses
  has_many :patients, :through => :suffered_illnesses
  
  def label
    name
  end
end
