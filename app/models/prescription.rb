class Prescription < ActiveRecord::Base
  attr_accessor :patient_name, :pharmacy_name, :send_to_patient
  
  belongs_to :patient
  belongs_to :physician
  belongs_to :pharmacy
  
  has_many :insurances, :as => :insurable, :dependent => :destroy
  has_many :insurers, :through => :insurances
  
  has_many :prescripts, :dependent => :destroy
  has_many :drugs, :through => :prescripts
  
  has_many :dispense_orders, :dependent => :destroy
  has_many :dispensories, :through => :dispense_orders, :source => :pharmacy
  has_many :dispensations, :through => :dispense_orders
  
  has_many :dispensables, :through => :dispense_orders
  
  accepts_nested_attributes_for :prescripts, :allow_destroy => true
  
  validates :identifier, :presence => true
  validates :identifier, :uniqueness => true
  validates :patient, :presence => true
  
  validates :verification_pin, :presence => true
  
  scope :active, -> {}
  
  before_validation do
    write_attribute(:verification_pin, generate_pin) unless read_attribute(:verification_pin).present?
  end
  
  before_validation do
    write_attribute(:identifier, generate_identifier) unless read_attribute(:identifier).present?
  end
  
  after_save do
    if pharmacy_id_changed?
      if pharmacy_id_was.nil?
        if ph = Pharmacy.find(pharmacy_id)
          ph.dispense_orders.create(
            prescription_id: self.id,
            dispensables_attributes: prescripts.map{ |p| { prescript_id: p.id } }
          )
        end
      else
        if ph = Pharmacy.find(pharmacy_id)
          transfer_to(ph)
          
          # FIXME: completely remove all open orders?
          dispense_orders.open.where('dispense_orders.prescription_id = ? AND pharmacy_id = ?', id, pharmacy_id_was).destroy_all
        end
      end
    end
    
    if self.send_to_patient == '1' || self.send_to_patient == true || self.send_to_patient == 'true'
      if patient.email_verified?
        PatientMailer.send_prescription(self).deliver_now
      end
      
      if patient.phone_verified?
        message = "Prescription #: #{self.identifier}\nSecurity: #{self.verification_pin}"
        
        puts "\n\n ****** #{message} ******\n\n"
        
        c = Twilio::REST::Client.new
        
        from = ENV["TWILIO_NUMBER"]
        to = "+1" + patient.phone_primary
        
        c.messages.create from: from, to: to, body: message
      end
    end
  end
  
  def transfer_to(ph, unfilled_only = true)
    pharma = ph.instance_of?(Pharmacy) ? ph : Pharmacy.find(ph).id rescue nil
    
    if pharma
      ps = (unfilled_only == true) ? self.dispensables.unfilled : self.dispensables
      
      ps.merge(DispenseOrder.open) # NOTE: only pull from dispense_orders that arent currently in processing
      
      if ps.length.zero?
        return false
      else
#         self.dispensables.pristine.destroy_all
        
#         self.dispense_orders.includes(:dispensables).where(:dispensables => { :id => nil }).destroy_all
        
        order = self.dispense_orders.open.find_by(pharmacy_id: pharma.id)
        
        if order.present?
          order.dispensable_ids = ps.pluck(:id)
          order.transferred_at = nil
          order.save
        else
          pharma.dispense_orders.create(
            prescription_id: self.id,
            dispensable_ids: ps.pluck(:id)
#             dispensables_attributes: ps.map{ |d| { prescript_id: d.prescript.id } }
          )
        end
        
      end
    end
  end
  
  def patient_name
    patient.label if patient.present?
  end
  
  def pharmacy_name
    pharmacy.label if pharmacy.present?
  end
  
  def ordinal_date
    "#{created_at.strftime("%b")} #{ created_at.day.ordinalize } #{created_at.strftime("%Y")}"
  end
  
  def transferrable?
    dispensables.length == 0 || dispensables.open.length > 0
  end
  
  def has_saved_patient?
    !(patient.present? && !patient.new_record?)
  end  
  
  def insurer_names
    insurers.map(&:name)
  end
  
  def mark_as_printed!
    update_attribute(:printed, true)
  end
  
  def send_to_patient?
    !!self.send_to_patient
  end
  
  def agency
    pharmacy
  end
  
  private
  
  def generate_identifier
    8.times.map { [*'0'..'9', *'a'..'z'].sample }.join.upcase
  end
  
  def generate_pin
    rand.to_s[2..5]
  end
end
