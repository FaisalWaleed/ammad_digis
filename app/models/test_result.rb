class TestResult < ActiveRecord::Base
  belongs_to :diagnostic
  has_one :laboratory, :through => :diagnostic
  
  has_many :attachments, :as => :attachable
  
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => :all_blank
  
  scope :archived_for_physician, -> { where('test_results.archived_for_physician = true') }
  scope :archived_for_technician, -> { where('test_results.archived_for_technician = true') }
  scope :unarchived_for_physician, -> { where('test_results.archived_for_physician != true') }
  scope :unarchived_for_technician, -> { where('test_results.archived_for_technician != true') }
  
  scope :viewed, -> { where('test_results.viewed = ?', true) }
  scope :recent, -> { where('test_results.viewed != ?', true) }
  
  def archive_for_physician!
    update_attribute(:archived_for_physician, true)
  end
  
  def archive_for_technician!
    update_attribute(:archived_for_technician, true)
  end
  
  def unarchive_for_physician!
    update_attribute(:archived_for_physician, false)
  end
  
  def unarchive_for_technician!
    update_attribute(:archived_for_technician, false)
  end
end
