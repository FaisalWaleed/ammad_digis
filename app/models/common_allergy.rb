class CommonAllergy < ActiveRecord::Base
  has_many :suffered_allergies
  has_many :patients, :through => :suffered_allergies
  
  def label
    name
  end
end
