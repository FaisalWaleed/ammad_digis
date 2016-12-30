class PatientNoteType < ActiveRecord::Base
  has_many :patient_notes
end
