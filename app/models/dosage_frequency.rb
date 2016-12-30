class DosageFrequency < ActiveRecord::Base
  
  def count
    (code.scan(/\d+/).last || 1).to_i
  end
end
