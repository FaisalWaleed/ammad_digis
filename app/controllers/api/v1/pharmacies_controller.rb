
module Api
  
  module V1
    
    class PharmaciesController < Api::ApiController
      
      def search
        term = params[:term]
        
        matches = Pharmacy.where('pharmacies.name ILIKE ?', "%#{term}%")
        
        
        render json: matches.to_json(
          :only => [ :id, :name ],
          :methods => [ :label ]
        )
        
      end
      
    end
    
  end
  
end
