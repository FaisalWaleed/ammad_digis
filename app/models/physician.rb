class Physician < ActiveRecord::Base
  acts_as_authentic do |config|
    config.email_field = :email_primary
  end
  
  has_age
  
  attr_accessor :terms_of_service
  
  has_many :payments, :as => :customer
  
  belongs_to :gender
  
  belongs_to :specialization, :class_name => 'PhysicianSpecialization'
  
  has_attached_file :avatar,
    :styles => { :large => "300x300#", :medium => "240x240#", :thumb => "128x128#", :small => "64x64#" },
    :url => "/uploads/:class/:attachment/:id/:style/:filename",
    :default_url => ":class/:attachment/:style/missing.png"
  
  has_attached_file :signature,
    :styles => { :large => "320", :medium => "240", :thumb => "128", :small => "64" },
    :url => "/uploads/:class/:attachment/:id/:style/:filename",
    :default_url => ":class/:attachment/:style/missing.png"
  
  
  has_many :patients
  has_many :prescriptions
  has_many :dispense_orders, :through => :prescriptions
  has_many :messages, :through => :dispense_orders
  
  has_many :diagnostics
  has_many :test_results, :class_name => 'Diagnostic'
  
  has_many :patient_notes, :as => :author
  
  has_many :messages, :as => :sender
  
  has_many :modified_diagnostics, :as => :last_modifier, :class_name => 'Diagnostic'
  has_many :modified_dispene_orders, :as => :last_modifier, :class_name => 'DispenseOrder'
  
  has_many :subscriptions, :as => :subscriber, :dependent => :destroy
  has_one :active_subscription, -> { merge(Subscription.valid) }, :as => :subscriber, :class_name => 'Subscription'
  
  has_many :authorizations
  has_many :authorized_patients, through: :authorizations, source: :patient
  
  accepts_nested_attributes_for :subscriptions, :allow_destroy => true, :reject_if => :all_blank
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :signature, content_type: /\Aimage\/.*\Z/
  validates :email_primary, :presence => true
  validates :password, :format => { :with => /\A(?=.{8,})(?=.*([a-z].*))(?=.*([A-Z].*))(?=.*(\d.*))(?=.*([!@#$%^&*(){}_=+<,>\/\[\]\.\-\\].*))(.*)\z/ }, :allow_blank => true
#   validates :reg_num, :presence => true
  
  validates :terms_of_service, :acceptance => true
  
  scope :active, -> { where('physicians.active = ?', true) }
  
  delegate :name, :to => :gender, :prefix => true, :allow_nil => true
  
  before_validation do
    @profile_was_incomplete = firstname_was.blank? ||
        lastname_was.blank? ||
        reg_num_was.blank? ||
        gender_id_was.blank? ||
        phone_primary_was.blank? ||
        email_primary_was.blank? ||
        address_street_1_was.blank? ||
        address_municipality_was.blank? ||
        address_territory_was.blank? ||
        address_country_was.blank?
    true
  end
  
  def name
    "#{ firstname } #{ lastname }"
  end
  
  def preferences
    PhysicianPreferences.new(self)
  end
  
  def unread_messages_count
    dispense_orders.waiting_on_dr(self).inject(0){|sum, o| sum + o.messages.unread.length } +
    diagnostics.waiting_on_dr(self).inject(0){|sum, d| sum + d.messages.unread.length }
  end
  
  def activate!
    update_attribute :active, true
  end
  
  def profile_complete?
    read_attribute(:firstname).present? &&
    read_attribute(:lastname).present? &&
    read_attribute(:reg_num).present? &&
    read_attribute(:gender_id).present? &&
    read_attribute(:phone_primary).present? &&
    read_attribute(:email_primary).present? &&
    read_attribute(:address_street_1).present? &&
    read_attribute(:address_municipality).present? &&
    read_attribute(:address_territory).present? &&
    read_attribute(:address_country).present?
  end
  
  def profile_was_incomplete?
    @profile_was_incomplete
  end
  
  def profile_newly_completed?
    profile_was_incomplete? && profile_complete?
  end
  
  def returning?
    subscriptions.length > 0
  end
  
  def unarchived_test_results
    diagnostics.unarchived_for_physician
  end
  
  def archived_test_results
    diagnostics.archived_for_physician
  end
  
  def specialization_name
    specialization.name rescue 'General Practice'
  end
end
