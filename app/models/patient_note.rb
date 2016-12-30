class PatientNote < ActiveRecord::Base
  belongs_to :author, :polymorphic => true
  belongs_to :patient
  belongs_to :patient_note_type
  
  validates :note, :presence => true
  validates :author, :presence => true
end
