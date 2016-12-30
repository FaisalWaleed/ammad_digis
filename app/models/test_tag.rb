class TestTag < ActiveRecord::Base
  belongs_to :test_type
  
  has_many :test_taggings
  has_many :tests, :through => :test_taggings
  
  has_many :testings, :through => :tests
  has_many :test_requests, :through => :testings, :class_name => 'Test', :source => :test
  
  scope :with_diagnostic, ->(d = Diagnostic.new){ joins(:test_requests).includes(:test_requests).where('tests.id IN (?)', d.test_ids).order('test_tags.id').distinct }
end
