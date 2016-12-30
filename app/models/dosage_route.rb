class DosageRoute < ActiveRecord::Base
  
  def code_with_name
    "#{code} (#{name})"
  end
end
