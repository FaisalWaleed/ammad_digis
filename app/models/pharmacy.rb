class Pharmacy < ActiveRecord::Base
  acts_as_authentic do |c|
    c.email_field = :email_primary
  end
  
  attr_accessor :terms_of_service
  
  has_many :dispense_orders, -> { uniq }
  has_many :prescriptions, :through => :dispense_orders
  
  has_many :dispensables, ->{distinct}, :through => :dispense_orders
  has_many :disbursements, ->{distinct}, :through => :dispensables
  
  has_many :pharmacy_vocations
  has_many :pharmacists, :through => :pharmacy_vocations
  
  has_many :prescription_transfers, :class_name => 'DispenseOrder', :foreign_key => :transferer_id
  
  has_many :subscriptions, :as => :subscriber, :dependent => :destroy
  has_one :active_subscription, -> { merge(Subscription.valid) }, :as => :subscriber, :class_name => 'Subscription'
  
  has_many :payments, :as => :customer
  
  has_attached_file :avatar,
    :styles => { :large => "300x300#", :medium => "240x240#", :thumb => "128x128#", :small => "64x64#" },
    :url => "/uploads/:class/:attachment/:id/:style/:filename",
    :default_url => ":class/:attachment/:style/missing.png"
  
  accepts_nested_attributes_for :subscriptions, :allow_destroy => true, :reject_if => :all_blank
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates :terms_of_service, :acceptance => true
  
  validates :password, :format => { :with => /\A(?=.{8,})(?=.*([a-z].*))(?=.*([A-Z].*))(?=.*(\d.*))(?=.*([!@#$%^&*(){}_=+<,>\/\[\]\.\-\\].*))(.*)\z/ }, :allow_blank => true

  scope :active, -> { where('pharmacies.active = ?', true) }
  
  before_validation do
    @profile_was_incomplete = name_was.blank? ||
        phone_primary_was.blank? ||
        email_primary_was.blank? ||
        address_street_1_was.blank? ||
        address_municipality_was.blank? ||
        address_territory_was.blank? ||
        address_country_was.blank?
    true
  end
  
  def identifier
    "#{ self.class.name.underscore }_#{self.id}"
  end
  
  def label
    name
  end
  
  def contact_name
    "#{contact_firstname} #{contact_lastname}"
  end
  
  def activate!
    update_attribute :active, true
  end
  
  def profile_complete?
    name.present? &&
        phone_primary.present? &&
        email_primary.present? &&
        address_street_1.present? &&
        address_municipality.present? &&
        address_territory.present? &&
        address_country.present?
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
end
