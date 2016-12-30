class TestProfile < ActiveRecord::Base
  attr_accessor :test_type_name
  
  belongs_to :test_type
  
  has_many :test_profilings, :dependent => :destroy
  has_many :tests, :through => :test_profilings
  
  validates :test_type, :presence => true
  
  has_many :testings, :through => :tests
  has_many :test_requests, :through => :testings, :class_name => 'Test', :source => :test
  
  scope :with_diagnostic, ->(d = Diagnostic.new){ joins(:test_requests).includes(:test_requests).where('tests.id IN (?)', d.test_ids).distinct }

  before_validation do
    unless self.test_type_name.to_s.strip.blank?
      self.test_type_id = (TestType.find_or_create_by(:name => self.test_type_name.strip, ).id)
    end
  end
end
