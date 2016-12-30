class Diagnostic < ActiveRecord::Base
  attr_accessor :send_to_patient, :laboratory_name
  
  has_many :messages, :as => :asset, :dependent => :destroy
  
  belongs_to :patient
  belongs_to :laboratory
  belongs_to :physician
  
  has_many :technicians, :through => :laboratory
  
  has_many :testings, :dependent => :destroy
  has_many :tests, :through => :testings
  has_many :test_types, :through => :tests
  has_many :test_tags, -> { distinct }, :through => :tests
  
  has_many :profiled_testings, :dependent => :destroy
  has_many :profiled_tests, :through => :profiled_testings, :class_name => 'Test', :source => :test
  has_many :test_profiles, -> { distinct }, :through => :profiled_testings
  
  belongs_to :last_modifier, :polymorphic => true
  
#   has_many :test_results
#   has_many :attachments, :through => :test_results
  has_many :attachments, :as => :attachable, :dependent => :destroy
  
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :profiled_testings, :allow_destroy => true, :reject_if => :all_blank
  
  scope :closed, -> { joins(:attachments).distinct }
  scope :open, -> { includes(:attachments).where(:attachments => { :attachable_id => nil }).distinct }
  
#   scope :waiting_on_dr, ->(dr) { joins(:messages, :physician).where('messages.read != ? AND sender_type = ? AND physicians.id = ?', true, 'Technician', dr.id).uniq }
#   scope :waiting_on_tech, ->(tc) { joins(:messages, :laboratory).where('messages.read != ? AND sender_type = ? AND laboratories.id = ?', true, 'Physician', tc.id).uniq }

  scope :waiting_on_dr, ->(dr) { joins(:messages, :physician).where('diagnostics.commentable = ? AND sender_type = ? AND physicians.id = ?', true, 'Technician', dr.id).uniq }
  scope :waiting_on_technician, ->(technician) { joins(:messages, :technicians).where('diagnostics.commentable = ? AND messages.sender_type = ? AND technicians.id = ?', true, 'Physician', technician.id).uniq }
  
  scope :resolved_for_dr, ->(dr) { joins(:messages, :physician).where('diagnostics.commentable != ? AND sender_type = ? AND physicians.id = ?', true, 'Technician', dr.id).uniq }
  scope :resolved_for_technician, ->(technician) { joins(:messages, :technicians).where('diagnostics.commentable != ? AND messages.sender_type = ? AND technicians.id = ?', true, 'Physician', technician.id).uniq }

  scope :archived_for_physician, -> { where('diagnostics.archived_for_physician = true') }
  scope :archived_for_technician, -> { where('diagnostics.archived_for_technician = true') }
  scope :unarchived_for_physician, -> { where('diagnostics.archived_for_physician != true') }
  scope :unarchived_for_technician, -> { where('diagnostics.archived_for_technician != true') }
  
  scope :reviewed, -> { where('diagnostics.reviewed = ?', true) }
  scope :unreviewed, -> { where('diagnostics.reviewed != ?', true) }
  scope :with_attachment, -> { joins(:attachments).distinct }
  scope :without_attachment, -> { includes(:attachments).where(attachments: { attachable_id: nil }) }
    
  scope :commentable, -> { where('diagnostics.commentable = ?', true) }
  scope :resolved, -> { where('diagnostics.commentable != ?', true) }
  
  scope :assigned, -> { where('laboratory_id IS NOT NULL') }
  scope :unassigned, -> { where('laboratory_id IS NULL') }
  
  validates :identifier, :presence => true
  validates :identifier, :uniqueness => true

  before_validation do
    write_attribute(:verification_pin, generate_pin) unless read_attribute(:verification_pin).present?
  end
  
  before_validation do
    write_attribute(:identifier, generate_identifier) unless read_attribute(:identifier).present?
  end
  
  before_validation do
    self.profiled_testings = profiled_testings - profiled_testings.select{ |t| t._permit.present? && t._permit.to_s != '1' }
  end
  
  after_save do
    if self.send_to_patient == '1' || self.send_to_patient == true || self.send_to_patient == 'true'
      if patient.email_verified?
        PatientMailer.send_diagnostic(self).deliver_now
      end
      
      if patient.phone_verified?
        message = "Lab Test #: #{self.identifier}\nSecurity: #{self.verification_pin}"
        
        puts "\n\n ****** #{message} ******\n\n"
        
        c = Twilio::REST::Client.new
        
        from = ENV["TWILIO_NUMBER"]
        to = "+1" + patient.phone_primary
        
        begin
          c.messages.create from: from, to: to, body: message
        rescue Exception => e
          #
        end
      end
    end
  end
  
  after_update do
    if self.reviewed != self.reviewed_was && self.reviewed? == false
      PhysicianMailer.test_result_requires_review(self).deliver_now
      
      Message.create(
        body: "A test result requires your attention",
        asset_type: self.class.name,
        asset_id: self.id,
        sender_type: last_modifier.class.name,
        sender_id: last_modifier.id,
        require_response: false,
        urgent: true
        )
    end
  end
  
  def has_saved_patient?
    !(patient.present? && !patient.new_record?)
  end  
  
  def closed?
    self.class.closed.include?(self)
  end
  
  def open?
    self.class.closed.exclude?(self)
  end
  
  def status
    if self.closed?
      return "closed"
    else
      return "open"
    end
  end
  
  def message_status
    if messages.present?
      if commentable?
        if messages.order(:created_at).last.sender.is_a?(Physician)
          return "waiting_on_tech"
        elsif messages.order(:created_at).last.sender.is_a?(Technician)
          return "waiting_on_dr"
        else
          return ""
        end
      else
        return "closed"
      end
    else
      return ""
    end
  end
  
  def transfer_to(lab)
    if lab.is_a?(Laboratory) && !lab.new_record?
      return update_attribute(:laboratory_id, lab.id)
    else
      return false
    end
  end
  
  def agency
    laboratory
  end
  
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
  
  def mark_as_reviewed!
    update_attribute :reviewed, true
  end
  
  def mark_as_unreviewed!
    update_attribute :reviewed, false
  end
  
  def ordinal_date
    "#{created_at.strftime("%b")} #{ created_at.day.ordinalize } #{created_at.strftime("%Y")}"
  end
  
  def all_tests
    tests + profiled_tests
  end
  
  def total_tests
    all_tests.length
  end
  
  def ready_for_review?
    attachments.size.nonzero? && !reviewed?
  end
  
  def test_center_type
    laboratory.test_types.map(&:name).first rescue nil
  end
  
  def messages_for_physician
    messages.where('messages.sender_type != ?', 'Physician')
  end
  
  def messages_for_technician
    messages.where('messages.sender_type != ?', 'Technician')
  end
  
  private
  
  def generate_identifier
    8.times.map { [*'0'..'9', *'a'..'z'].sample }.join.upcase
  end
  
  def generate_pin
    rand.to_s[2..5]
  end
end
