class DosageDurationUnit < ActiveRecord::Base
  attr_accessor :temp_value
  
  def label
    "#{ temp_value.match(/\d+/)[0] rescue '' } / #{ code }"
  end
end
