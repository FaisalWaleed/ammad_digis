require 'csv'

class Drug < ActiveRecord::Base
  belongs_to :drug_format
  
  has_many :dosage_units, :through => :drug_format
  
  has_many :routabilities
  has_many :dosage_routes,:through => :routabilities
  
  delegate :name, :to => :drug_format, :prefix => true
  
  def self.import(purge_before = false)
    fn = Rails.root.to_s + '/import/drugs.csv'

    rows = CSV.parse(File.read(fn), :headers => true, :skip_blanks => true)
    
    rows = rows.delete_if { |row| row.to_hash.values.all?(&:blank?) ||
                            (row['TRADE NAME'].blank? && row['GENERIC NAME'].blank?)
                            }
    
    return if rows.empty?
    
    if purge_before
      Drug.destroy_all 
      DrugFormat.destroy_all 
      DosageUnit.destroy_all 
      Prescription.destroy_all 
    end
    
    rows.each do |row|
      begin
        dosage_units = []
        dosage_routes = []

        row['DISPLAY UNITS'].split(',').each do |unit|
          if unit.present? && unit.to_s.strip != '-'
            name, symbol = unit.split('|')
            
            dosage_units << DosageUnit.find_or_create_by(name: name, symbol: symbol)
          end
        end
        
        row['ROUTE'].split(',').each do |unit|
          if unit.present? && unit.to_s.strip != '-'
            name, code = unit.split('|')
            
            dosage_routes << DosageRoute.find_or_create_by(name: name, code: code)
          end
        end
        
        format = DrugFormat.find_or_create_by(
          name: row['POSOLOGY']
        )
        
        dosage_units.each do |u|
          format.dosage_units << u unless format.dosage_unit_ids.include?(u.id)
        end
        
        drug = Drug.create(
          trade_name: row['TRADE NAME'],
          generic_name: row['GENERIC NAME'],
          drug_format_id: format.id,
          dosages: row['DOSE/UNITS']
        )
        
        if drug
          dosage_routes.each do |r|
            drug.dosage_routes << r unless drug.dosage_route_ids.include?(r.id)
          end
        end
        
      rescue Exception => e
        puts "\n\n #{e} \n\n"
      end
      
    end
  end
  
  def label
    "#{trade_name} ( #{generic_name} ) #{drug_format.name rescue nil} #{dosages}"
  end
  
  def strength
    dosages.scan(/\d+/).first.to_f
  end
end
