module ActsAsAgeable
  extend ActiveSupport::Concern
  
  module ClassMethods
    
    def has_age(config = {})
      
      if self.column_names.include?(config[:date_column].to_s)
        create_methods_for(config[:date_column])
      else
        detect_column
      end
      
    end
    
    private
    
    def detect_column
      dob_columns = [:dob, :birthdate, :date_of_birth]
      
      dob_columns.each_with_index do |c, i|
        if self.column_names.include?(c.to_s)
          create_methods_for(c)
          
          break
        end
      end
    end
    
    def create_methods_for c
      singleton_class.instance_eval do
        define_method :avg_age do |as_at = Time.now|
          scoped = all.all
          scoped.inject(0){ |sum, c| c.age(as_at).to_i + sum } / scoped.length rescue 0
        end
      end
      
      
      define_method :age do |as_at = Time.now|
        
        dob = self.send(c) 
        
        if dob.present?
          return nil unless dob.respond_to?(:day)
          
          dob = dob.to_date
          
          as_at = as_at.utc.to_date if as_at.respond_to?(:utc)
          return (as_at.year - dob.year).to_i - ((as_at.month > dob.month || (as_at.month == dob.month && as_at.day >= dob.day)) ? 0 : 1)
        else
          return nil
        end
        
      end
      
      define_method 'age=' do |num|
        write_attribute c.to_sym, (Time.now.to_date - num.to_i.years)
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsAgeable)