class Prescript < ActiveRecord::Base
  attr_accessor :drug_name, :duration_with_unit
  
  belongs_to :drug
  belongs_to :prescription
  belongs_to :dosage_unit
  belongs_to :dosage_route
  belongs_to :dosage_frequency
  belongs_to :dosage_duration_unit
  
  has_one :pharmacy, :through => :prescription
  has_one :physician, :through => :prescription
  has_one :patient, :through => :prescription
  
  has_many :dispensables, :dependent => :destroy
  has_many :dispensations, :through => :dispensables
  has_many :disbursements, ->{distinct}, :through => :dispensables
  
  validates :drug, :presence => true, :if => :fixed_form?
  validates :dose, :presence => true, :if => :fixed_form?
  validates :repeat_max, :presence => true, :unless => :frequency_is_stat?
  #   validates :dosage_unit, :presence => true, :unless => Proc.new { |p| p.free_flow? }
  validates :dosage_route, :presence => true, :if => :fixed_form?
  validates :dosage_frequency, :presence => true, :if => :fixed_form?
#   validates :dosage_duration_unit, :presence => true, :unless => Proc.new { |p| p.frequency_is_stat? || p.free_flow? }
  
#   validates :duration_with_unit, :format => { :with => /\d{1,2}\s*\/\s*\d{1,2}/, :message => 'must be of the form: \'nn / nn\'' }
  
  scope :filled, -> { where('(COALESCE(prescripts.repeat_max, 0) - COALESCE(prescripts.repeat_count, 0)) = 0') }
  scope :unfilled, -> { where('(COALESCE(prescripts.repeat_max, 0) - COALESCE(prescripts.repeat_count, 0)) > ? OR (COALESCE(prescripts.repeat_count, 0)) = ?', 0, 0) }
  scope :over_filled, -> { where('(COALESCE(prescripts.repeat_max, 0) - COALESCE(prescripts.repeat_count, 0)) < 0') }
  scope :pristine, -> { where('(COALESCE(prescripts.repeat_count, 0)) = ?', 0) }
  
  scope :ongoing, -> { where('(COALESCE(prescripts.repeat_max, 0) - COALESCE(prescripts.repeat_count, 0)) > ? AND (COALESCE(prescripts.repeat_count, 0)) >= ?', 0, 1) } 
  scope :partial, -> { joins(:dispensables => :disbursements).merge(Dispensable.partial).distinct } 
  
  after_initialize do
    if self.posology_code == "3"
      write_attribute :free_flow, true
    elsif self.posology_code == "2"
      write_attribute :semi_free_flow, true
    end
  end
  
  def duration_with_unit=(val)
    unless val.blank? || frequency_is_stat?
      duration, unit = val.split('/').map(&:strip)
      
      write_attribute :dosage_duration, duration
      write_attribute :dosage_duration_unit_id, (DosageDurationUnit.find_by(code: unit).id rescue nil)
    end
  end
  
  validate do |p|
    if (p.fixed_form?) && (p.duration_with_unit.blank? || !p.duration_with_unit.match(/\d{1,2}\s*\/\s*\d{1,2}/))
      p.errors[:dosage_duration] << "must be of the format: 'nn / nn'" unless p.frequency_is_stat?
    end
  end
  
  def duration_with_unit
    "#{dosage_duration.to_i} / #{dosage_duration_unit.code.to_i}" rescue nil
  end
  
  def drug_name
    drug.label if drug.present?
  end
  
  def frequency_is_stat?
    dosage_frequency.code.parameterize.to_sym == :stat rescue false
  end
  
  def increment_repeats!
    update_attribute(:repeat_count, read_attribute(:repeat_count).to_i + 1)
  end
  
  def decrement_repeats!
    update_attribute(:repeat_count, read_attribute(:repeat_count).to_i - 1)
  end
  
  def filled?
    self.class.filled.include?(self)
  end
  
  def unfilled?
    self.class.unfilled.include?(self)
  end
  
  def over_filled?
    self.class.over_filled.include?(self)
  end
  
  def repeats_remaining
    repeat_max - repeat_count
  end
  
  def repeating?
    repeat_max > 0
  end
  
  # %t = Drug Trade Name
  # %g = Drug Generic Name
  # %f = Drug FOrmat
  # %o = Drug Dosages
  # %d = Precribed Dose
  # %u = Dosage Unit
  # %r = Doage Route
  # %q = Dosage Frequency
  # %w = Duration with Unit
  def strfrx(str = "%t (%g) %f %o %d %u %r %q x %w")
    unless duration_with_unit.present?
      str.gsub!(/\s+x\s+%w/, '')
    end
    
    str.gsub!('%t', (drug.trade_name || ''))
    str.gsub!('%g', (drug.generic_name || ''))
    str.gsub!('%f', (drug.drug_format.name rescue ''))
    str.gsub!('%o', (drug.dosages.to_s rescue ''))
    str.gsub!('%d', ("%g" % dose.to_f).to_s)
    str.gsub!('%u', (dosage_unit.name.humanize rescue ''))
    str.gsub!('%r', (dosage_route.code.to_s rescue ''))
    str.gsub!('%q', (dosage_frequency.code.to_s rescue ''))
    str.gsub!('%w', duration_with_unit.presence.to_s)
    
    str.gsub!(/\s+/, ' ')
  end
  
  def posology_code
    fmt = (drug.drug_format.name rescue nil).to_s
    
    n1 = [ "Caplet", "Capsule", "Chewtab", "Effervescent tablet", "Elixir", "Linctus", "Lozenge", "Oral drops", "Ovules", "Pessaries", "Softgel", "Suppository", "Suspension", "Syrup", "Tablet" ]
    
    n2 = [ "Aerosol", "Capsule for inhalation", "Cream", "Crystals", "Dermgel", "Diskus", "DPI", "Dressing", "Drops", "Emulsion", "Enema", "Evohaler", "Gel", "Inhaler", "Injection", "Liquid", "Lotion", "MDI", "Nail lacquer", "Nasal spray", "Nebulizer solution/suspension", "Ointment", "Otic drops", "Ophthalmic drops/solution", "Packet", "Powder", "Shampoo", "Soap", "Solution", "Spray", "Turbohaler" ]
    
    n3 = [ "Bar", "Bracelet" ]
    
    if n1.map(&:parameterize).include?(fmt.parameterize)
      return "1"
    elsif n2.map(&:parameterize).include?(fmt.parameterize)
      return "2"
    elsif n3.map(&:parameterize).include?(fmt.parameterize)
      return "3"
    else
      return "4"
    end
  end
  
  def fixed_form?
    !(free_flow? || semi_free_flow?)
  end
end
