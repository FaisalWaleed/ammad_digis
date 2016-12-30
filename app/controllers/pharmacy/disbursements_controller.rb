class Pharmacy::DisbursementsController < Pharmacy::BaseController
  def index
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    
    @disbursements = current_pharmacy.disbursements
    
    if @start_date.present?
      @disbursements = @disbursements.where('disbursements.created_at >= ?', @start_date.to_date)
    end
    
    if @end_date.present?
      @disbursements = @disbursements.where('disbursements.created_at <= ?', @end_date.to_date)
    end
    
    respond_to do |format|
      format.html do |html|
        html.print do
          render layout: 'disbursement-print'
        end
      end
    end
  end
  
  def show
    @disbursement = current_pharmacy.disbursements.find(params[:id])
    render partial: 'partials/modals/pharmacy/disbursement_modal'
  end
  
end
