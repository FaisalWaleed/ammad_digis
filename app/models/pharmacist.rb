class Pharmacist < ActiveRecord::Base
  acts_as_authentic do |config|
    config.email_field = :email_primary
  end
  has_age
  
  attr_accessor :terms_of_service
  
  has_many :payments, :as => :customer
  
  belongs_to :gender
  
  has_attached_file :avatar,
    :styles => { :large => "300x300#", :medium => "240x240#", :thumb => "128x128#", :small => "64x64#" },
    :url => "/uploads/:class/:attachment/:id/:style/:filename",
    :default_url => ":class/:attachment/:style/missing.png"
    
  has_many :pharmacy_vocations
  has_many :pharmacies, :through => :pharmacy_vocations
  
  has_many :messages, :as => :sender
  
  has_many :modified_dispene_orders, :as => :last_modifier, :class_name => 'DispenseOrder'
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
#   validates :reg_num, :presence => true
  
  validates :password, :format => { :with => /\A(?=.{8,})(?=.*([a-z].*))(?=.*([A-Z].*))(?=.*(\d.*))(?=.*([!@#$%^&*(){}_=+<,>\/\[\]\.\-\\].*))(.*)\z/ }, :allow_blank => true
#   validates :date_of_birth, :presence => true
  
  validates :terms_of_service, :acceptance => true
  
  scope :active, -> { where('pharmacists.active = ?', true) }
  
  delegate :name, :to => :gender, :prefix => true
  
  def identifier
    "#{ self.class.name.underscore }_#{self.id}"
  end
  
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
  
  def returning?
    subscriptions.length > 0
  end
  
  def unread_messages_count_for(pharmacy)
    pharmacy.dispense_orders.waiting_on_pharmacist(self).inject(0){|sum, o| sum + o.messages.unread.length }
  end
  
end
