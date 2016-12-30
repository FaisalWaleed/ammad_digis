
module Api
  
  module V1
    
    class IllnessesController < Api::ApiController
      
      def search
        term = params[:term]
        
        matches = CommonIllness.where('common_illnesses.name ILIKE ? OR common_illnesses.aliases ILIKE ?', "#{term}%", "#{term}%")
        
        
        render json: matches.to_json(
          :only => [ :id, :name ],
          :methods => [ :label ]
        )
        
      end
      
    end
    
  end
  
end
