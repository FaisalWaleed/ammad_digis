
module Api
  
  module V1
    
    class DosageDurationUnitsController < Api::ApiController
      
      def search
        term = params[:term]
        
        duration, unit = term.split('/').map(&:strip)
        
        # TODO: check if we need to change this syntax if/when we move over to postgres
        matches = DosageDurationUnit.where('CAST(dosage_duration_units.threshold AS Integer) >= ? AND CAST(dosage_duration_units.code AS Integer) >= ?', duration.to_i, unit.to_i)
        
        matches.each { |m| m.temp_value = term }
        
        render json: matches.to_json(
          :only => [ :id, :name, :code ],
          :methods => [ :label ]
        )
        
      end
      
    end
    
  end
  
end
