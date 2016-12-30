require 'csv'

class Test < ActiveRecord::Base
  attr_accessor :test_type_name, :test_tag_names
  
  belongs_to :test_type
  
  has_many :testings, :dependent => :destroy
  has_many :diagnostics, :through => :testings
  
  has_many :test_taggings, :dependent => :destroy
  has_many :test_tags, -> { distinct.order(:id) }, :through => :test_taggings
  
  has_many :test_profilings, :dependent => :destroy
  has_many :test_profiles, :through => :test_profilings

  accepts_nested_attributes_for :test_tags, :allow_destroy => true, :reject_if => :all_blank
  
  validates :test_type, :presence => true
  
  before_validation do
    unless self.test_type_name.to_s.strip.blank?
      self.test_type_id = (TestType.find_or_create_by(:name => self.test_type_name.strip, ).id)
    end

    if self.test_type_id.present?
      arr_names = self.test_tag_names.to_s.split(',').map(&:strip)
      
      arr_names.each do |n|
        self.test_tag_ids += [TestTag.find_or_create_by(:name => n.strip, :test_type_id => self.test_type_id).id]
      end
    end
  end
  
  def self.import(purge_before = false)
    fn = Rails.root.to_s + '/import/tests.csv'
    
    rows = CSV.parse(File.read(fn), :headers => true, :skip_blanks => true)
    
    rows = rows.delete_if { |row| row.to_hash.values.any?(&:blank?) }
    
    return if rows.empty?
    
    if purge_before
      Test.destroy_all 
      TestType.destroy_all 
      TestTag.destroy_all 
    end
    
    rows.each do |row|
      begin
        
        type = TestType.find_or_create_by(
          name: row['Test Type']
          )
        
        if type.present?
          row['Tags'].split(',').each do |tag|
            if tag.present?
              type.test_tag_ids += [TestTag.find_or_create_by(name: tag).id]
            end
          end
          
          if row['Test Name'].present?
            test = type.tests.create(name: row['Test Name'])

            if test.present?
              row['Tags'].split(',').each do |tag|
                if tag.present?
                  test.test_tag_ids += [TestTag.find_or_create_by(name: tag).id]
                end
              end
            end
          end
        end
        
      rescue Exeption => e
        
      end
    end
  end
end
