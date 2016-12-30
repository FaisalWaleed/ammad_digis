
module Api
  
  module V1
    
    class LaboratoriesController < Api::ApiController
      
      def search
        term = params[:term]
        type_ids = params[:test_type_ids] || []
        
        matches = Laboratory.where('laboratories.name ILIKE ?', "%#{term}%")
        
        if type_ids.present?
          matches = matches.joins(:test_types).where('test_types.id IN (?)', type_ids)
        end
        
        render json: matches.to_json(
          :only => [ :id, :name ],
          :methods => [ :label ]
        )
        
      end
      
    end
    
  end
  
end
