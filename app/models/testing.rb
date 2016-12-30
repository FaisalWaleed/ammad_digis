class Testing < ActiveRecord::Base
  belongs_to :test
  belongs_to :diagnostic
  
  has_many :profiles, -> { distinct }, :through => :test, :class_name => 'TestProfile', :source => :test_profiles
  
  def status
    unless completed?
      return 'open'
    else
      return 'closed'
    end
  end
end
