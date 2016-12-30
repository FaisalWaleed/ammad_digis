class Technician < ActiveRecord::Base
  acts_as_authentic do |config|
    config.email_field = :email_primary
  end
  
  has_age
  
  attr_accessor :terms_of_service
  
  belongs_to :gender
  
  has_many :payments, :as => :customer
  
  has_attached_file :avatar,
    :styles => { :large => "300x300#", :medium => "240x240#", :thumb => "128x128#", :small => "64x64#" },
    :url => "/uploads/:class/:attachment/:id/:style/:filename",
    :default_url => ":class/:attachment/:style/missing.png"
  
  
  has_many :laboratory_vocations
  has_many :laboratories, :through => :laboratory_vocations
  
  belongs_to :location
  
  has_many :messages, :as => :sender
  
  has_many :modified_diagnostics, :as => :last_modifier, :class_name => 'Diagnostic'
  
  has_many :subscriptions, :as => :subscriber, :dependent => :destroy
  has_one :active_subscription, -> { where('subscriptions.active = ? AND subscriptions.expire_at > ?', true, Time.now) }, :as => :subscriber, :class_name => 'Subscription'
  
  accepts_nested_attributes_for :subscriptions, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :location, :allow_destroy => true, :reject_if => :all_blank
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates :email_primary, :presence => true
  validates :password, :format => { :with => /\A(?=.{8,})(?=.*([a-z].*))(?=.*([A-Z].*))(?=.*(\d.*))(?=.*([!@#$%^&*(){}_=+<,>\/\[\]\.\-\\].*))(.*)\z/ }, :allow_blank => true
#   validates :reg_num, :presence => true
  
#   validates :date_of_birth, :presence => true
  
  validates :terms_of_service, :acceptance => true
  
  scope :active, -> { where('technicians.active = ?', true) }
  
  delegate :name, :to => :gender, :prefix => true
  
  def name
    "#{ firstname } #{ lastname }"
  end
  
  def activate!
    update_attribute :active, true
  end
  
  def profile_complete?
    firstname.present? &&
        lastname.present? &&
        reg_num.present? &&
        gender_id? &&
        phone_primary.present? &&
        email_primary.present? &&
        address_street_1.present? &&
        address_municipality.present? &&
        address_territory.present? &&
        address_country.present?
  end
  
  def unarchived_test_results
    test_results.unarchived_for_technician
  end
  
  def returning?
    subscriptions.length > 0
  end
  
  def unread_messages_count_for(laboratory)
    laboratory.diagnostics.waiting_on_technician(self).inject(0){|sum, d| sum + d.messages.unread.length }
  end
end
