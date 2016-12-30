class Patient < ActiveRecord::Base
  acts_as_authentic do |c|
    c.email_field = :email_primary
  end

  attr_accessor :general_note, :old_password
  
  has_attached_file :avatar,
    :styles => { :large => "300x300#", :medium => "240x240#", :thumb => "128x128#", :small => "64x64#" },
    :url => "/uploads/:class/:attachment/:id/:style/:filename",
    :default_url => ":class/:attachment/:style/missing.png"
  
  has_many :subscriptions, :as => :subscriber
  
  has_many :notes, :class_name => 'PatientNote'
  has_many :prescriptions
  
  has_many :prescribed_drugs, -> { uniq }, :through => :prescriptions, :source => :prescripts
  
  has_many :suffered_allergies, :dependent => :destroy
  has_many :common_allergies, :through => :suffered_allergies
  
  has_many :suffered_illnesses, :dependent => :destroy
  has_many :common_illnesses, :through => :suffered_illnesses
  
  has_many :diagnostics

  has_many :authorizations
  has_many :authorized_physicians, through: :authorizations, source: :physician
  
  belongs_to :physician
  belongs_to :gender
  belongs_to :personal_id_type # TODO: change this to a has_many
  
  accepts_nested_attributes_for :notes
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :date_of_birth, :presence => true
  validates :gender, :presence => true
#   validates :address_street_1, :presence => true
#   validates :address_municipality, :presence => true
#   validates :address_territory, :presence => true
  
  delegate :name, :to => :gender, :prefix => true
  
  def allergies=(list)
    return unless list.present?

    coll = list.map do |name|
      CommonAllergy.find_or_create_by(:name => name) unless name.blank?
    end
    
    self.common_allergy_ids = coll.compact.map(&:id) if coll.present?
    self.save!
  end
  
  def illnesses=(list)
    return unless list.present?

    coll = list.map do |name|
      CommonIllness.find_or_create_by(:name => name) unless name.blank?
    end
    
    self.common_illness_ids = coll.compact.map(&:id) if coll.present?
    self.save!
  end
  
  def address=(val)
    street_1, street_2, territory, municipality, postal_code, country = val.split(',').map(&:strip)
    
    write_attribute :address_street_1, street_1
    write_attribute :address_street_2, street_2
    write_attribute :address_municipality, municipality
    write_attribute :address_territory, territory
#     write_attribute :address_postal_code, postal_code
    write_attribute :address_country, country
  end
  
  def address
    [
      address_street_1.presence,
      address_street_2.presence,
      address_municipality.presence,
      address_territory.presence,
      address_postal_code.presence,
      address_country.presence
    ].compact.join(', ')
  end
  
  def name
    "#{ read_attribute :firstname } #{ read_attribute :lastname }".strip
  end
  
  def name=(val)
    names = val.split
    
    first = names.shift
    last = names.pop
    middle = names.join(' ')
    
    write_attribute :firstname, first if first
    write_attribute :lastname, last if last
    write_attribute :middlename, middle if middle
  end
  
  def label
    name
  end
  
  def age(as_at=Time.now)
    return unless date_of_birth.respond_to?(:day)
    
    dob = date_of_birth.to_date
    
    as_at = as_at.utc.to_date if as_at.respond_to?(:utc)
    (as_at.year - dob.year).to_i - ((as_at.month > dob.month || (as_at.month == dob.month && as_at.day >= dob.day)) ? 0 : 1)
  end
  
  def gender_abbrev
    gender.name.to_s.first
  end
  
  def avatar_urls
    {
      large: avatar.url(:large),
      medium: avatar.url(:medium),
      small: avatar.url(:small),
      thumb: avatar.url(:thumb),
      tiny: avatar.url(:tiny)
    }
  end
  
  def generate_pin
    rand.to_s[2..5]
  end

  def authorized(physician_ids)
    physicians = Physician.where(id: physician_ids).pluck(:id)

    physicians.each do |physician|
      Authorization.create(physician_id: physician, patient_id: self.id)
    end
  end

  def unauthorized(physician_ids)
    self.authorizations.where(physician_id: physician_ids).destroy_all
  end
end
