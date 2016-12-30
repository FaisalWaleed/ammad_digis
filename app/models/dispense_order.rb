class DispenseOrder < ActiveRecord::Base
  attr_accessor :pharmacy_name, :identifier, :verification_pin
  
  belongs_to :prescription
  belongs_to :pharmacy
  
  has_many :pharmacists, :through => :pharmacy
  
  belongs_to :transferer, :class_name => 'Pharmacy'
  
  has_many :prescripts, :through => :prescription
  
  has_many :consignments, :dependent => :destroy
  
  has_many :dispensables, -> { uniq }, :through => :consignments
  has_many :dispensations, :through => :dispensables
  has_many :drugs, :through => :dispensables
  
  has_many :messages, :as => :asset, :dependent => :destroy
  
  has_one :patient, :through => :prescription
  has_one :physician, :through => :prescription
  
  accepts_nested_attributes_for :dispensables
  accepts_nested_attributes_for :messages
  
  scope :active, ->{ where('dispense_orders.delivered_at IS NULL') }
  scope :inactive, ->{ where('dispense_orders.delivered_at IS NOT NULL') }
  
  scope :open, ->{ where('dispense_orders.processing_at IS NULL AND dispense_orders.ready_at IS NULL AND dispense_orders.delivered_at IS NULL') }
  scope :processing, ->{ where('dispense_orders.processing_at IS NOT NULL') }
  scope :ready, ->{ where('dispense_orders.ready_at IS NOT NULL') }
  scope :delivered, ->{ where('dispense_orders.ready_at IS NOT NULL AND dispense_orders.delivered_at IS NOT NULL') }
  scope :locked, ->{ where('dispense_orders.ready_at IS NOT NULL OR dispense_orders.delivered_at IS NOT NULL') }
  
  scope :transferred, ->{ where('dispense_orders.transferred_at IS NOT NULL') }
  
  scope :relevant, -> { where('(dispense_orders.delivered_at IS NULL OR dispense_orders.delivered_at > ?) AND dispense_orders.transferred_at IS NULL AND dispense_orders.ongoing != ?', 1.hour.ago, true) }
  scope :filled, -> { joins(:prescripts).merge(Prescript.filled) }
  scope :unfilled, -> { joins(:prescripts).merge(Prescript.unfilled) }
  scope :over_filled, -> { joins(:prescripts).merge(Prescript.over_filled) }
  
  scope :commentable, -> { where('dispense_orders.commentable = ?', true) }
  scope :resolved, -> { where('dispense_orders.commentable != ?', true) }
  
  scope :waiting_on_dr, ->(dr) { joins(:messages, :physician).where('dispense_orders.commentable = ? AND sender_type = ? AND physicians.id = ?', true, 'Pharmacist', dr.id).uniq }
  scope :waiting_on_ph, ->(ph) { joins(:messages, :pharmacy).where('dispense_orders.commentable = ? AND sender_type = ? AND pharmacies.id = ?', true, 'Physician', ph.id).uniq }
  
  scope :waiting_on_pharmacist, ->(pharmacist) { joins(:messages, :pharmacists).where('dispense_orders.commentable = ? AND messages.sender_type = ? AND pharmacists.id = ?', true, 'Physician', pharmacist.id).uniq }
  
  scope :resolved_for_dr, ->(dr) { joins(:messages, :physician).where('dispense_orders.commentable != ? AND sender_type = ? AND physicians.id = ?', true, 'Pharmacist', dr.id).uniq }
  scope :resolved_for_pharmacist, ->(pharmacist) { joins(:messages, :pharmacists).where('dispense_orders.commentable != ? AND messages.sender_type = ? AND pharmacists.id = ?', true, 'Physician', pharmacist.id).uniq }
  
#   scope :ongoing, -> { where('dispense_orders.ongoing = ?', true) }
  scope :ongoing, -> { joins(:dispensables => [:disbursements, :prescript]).where('dispensables.fully_filled != true OR ((COALESCE(prescripts.repeat_max, 0) - COALESCE(prescripts.repeat_count, 0)) > ? AND (COALESCE(prescripts.repeat_count, 0)) >= ?)', 0, 1).distinct }
  
  #   def self.waiting_on_dr
#     find_by_sql("
#     SELECT o.* FROM dispense_orders o 
#     INNER JOIN messages m1 ON m1.sender_type = 'Pharmacist' AND m1.asset_id = o.id AND m1.asset_type='DispenseOrder'  AND m1.require_response = #{DB_BOOL_TRUE} 
#     LEFT OUTER JOIN messages m2 ON m2.sender_type = 'Pharmacist' AND m2.asset_id = o.id AND m2.asset_type='DispenseOrder' AND m1.created_at > m2.created_at 
#     WHERE o.commentable = #{DB_BOOL_TRUE} AND m2.id IS NULL
#     ")
#   end
#   
#   def self.waiting_on_ph
#     find_by_sql("
#     SELECT o.* FROM dispense_orders o 
#     INNER JOIN messages m1 ON m1.sender_type = 'Physician' AND m1.asset_id = o.id AND m1.asset_type='DispenseOrder' AND m1.require_response = #{DB_BOOL_TRUE} 
#     LEFT OUTER JOIN messages m2 ON m2.sender_type = 'Physician' AND m2.asset_id = o.id AND m2.asset_type='DispenseOrder' AND m1.created_at > m2.created_at 
#     WHERE o.commentable = #{DB_BOOL_TRUE} AND m2.id IS NULL
#     ")
#   end
  
  def processing!
    update_attribute :processing_at, Time.now
  end
  
  def ready!(params = {})
    params.merge!(ready_at: Time.now)
    update_attributes(params)
    
#     update_ongoing!
  end
  
  def delivered!
    update_attribute :delivered_at, Time.now
#     dispensables.each { |d| d.dispensations.create!(dispensable_id: self.id) }
  end
  
  def update_ongoing!
    update_attribute :ongoing, self.has_partials?
  end
  
  def has_partials?
    dispensables.ongoing.count > 0 || dispensables.partial.count > 0
  end
  
  def status
    if delivered_at.present?
      "delivered"
    elsif ready_at.present?
      "ready"
    elsif processing_at.present?
      "processing"
    elsif transferred_at.present?
      "partial"
    else
      "open"
    end
      
  end
  
  def processing?
    processing_at.present?
  end
  
  def ready?
    ready_at.present?
  end
  
  def delivered?
    delivered_at.present?
  end
  
  def locked?
    processing? || ready? || delivered?
  end
  
  def active?
    !delivered?
  end
  
  def inactive?
    delivered?
  end
  
  def message_status
    if messages.present?
      if commentable?
        if messages.order(:created_at).last.sender.is_a?(Physician)
          return "waiting_on_ph"
        elsif messages.order(:created_at).last.sender.is_a?(Pharmacist)
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
  
  def agency
    pharmacy
  end
  
  def identifier
    prescription.identifier rescue nil
  end
  
  def messages_for_physician
    messages.where('messages.sender_type != ?', 'Physician')
  end
  
  def messages_for_pharmacist
    messages.where('messages.sender_type != ?', 'Pharmacist')
  end
  
  private
  
end
