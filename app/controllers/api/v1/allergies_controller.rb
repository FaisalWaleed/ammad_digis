
module Api
  
  module V1
    
    class AllergiesController < Api::ApiController
      
      def search
        term = params[:term]
        
        matches = CommonAllergy.where('common_allergies.name ILIKE ? OR common_allergies.aliases ILIKE ?', "#{term}%", "#{term}%")
        
        
        render json: matches.to_json(
          :only => [ :id, :name ],
          :methods => [ :label ]
        )
        
      end
      
    end
    
  end
  
end
