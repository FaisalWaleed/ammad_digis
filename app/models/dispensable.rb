class Dispensable < ActiveRecord::Base
  attr_accessor :process
  
  has_many :consignments
  has_many :dispense_orders, :through => :consignments
  belongs_to :prescript
  
  has_one :pharmacy, :through => :prescript
  has_one :prescription, :through => :prescript
  has_one :physician, :through => :prescript
  
  has_one :drug, :through => :prescript
  has_one :dosage_frequency, :through => :prescript
  
  has_many :dispensations, :dependent => :destroy
  
  has_many :disbursements, :dependent => :destroy
  
  accepts_nested_attributes_for :disbursements, :allow_destroy => true, :reject_if => :all_blank
  
  scope :filled, -> { joins(:prescript).merge(Prescript.filled) }
  scope :unfilled, -> { joins(:prescript).merge(Prescript.unfilled) }
  scope :over_filled, -> { joins(:prescript).merge(Prescript.over_filled) }
  scope :pristine, -> { joins(:prescript).merge(Prescript.pristine) }
  
  scope :open, -> { joins(:dispense_orders).merge(DispenseOrder.open) }
  scope :ongoing, -> { joins(:prescript).merge(Prescript.ongoing) }
  
  scope :partial, -> { joins(:disbursements).where('dispensables.fully_filled != ?', true).distinct }
  
  delegate :repeat_max, :to => :prescript, :prefix => false, :allow_nil => true
  delegate :repeat_count, :to => :prescript, :prefix => false, :allow_nil => true
  delegate :dose, :to => :prescript, :prefix => false, :allow_nil => true
  delegate :count, :to => :dosage_frequency, :prefix => true, :allow_nil => true
  delegate :dosage_duration, :to => :prescript, :prefix => false, :allow_nil => true
  delegate :strength, :to => :drug, :prefix => true, :allow_nil => true
  
  after_save do
    if fully_filled?
      prescript.increment_repeats!
    end
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
  
  def status
    if filled?
      return 'filled'
    elsif over_filled?
      return 'over-filled'
    elsif unfilled?
      return 'unfilled'
    else
      return 'unknown'
    end
  end
  
  def process?
    self.process == '1' || self.process == true || self.process == 'true'
  end
  
  def dose_total
    dose * dosage_duration * dosage_frequency_count * drug_strength
  end
  
  def dose_unfilled
    dose_total.to_f - (dose_filled.to_f * strength_filled.to_f)
  end
end
