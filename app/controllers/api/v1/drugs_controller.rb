
module Api
  
  module V1
    
    class DrugsController < Api::ApiController
      
      def search
        term = params[:term]
        
        matches = Drug.where('drugs.trade_name ILIKE ? OR drugs.generic_name ILIKE ?', "#{term}%", "#{term}%")
        
        
        render json: matches.to_json(
          :only => [ :id, :trade_name, :generic_name ],
          :methods => [ :label ]
          )
        
      end
      
    end
    
  end
  
end
