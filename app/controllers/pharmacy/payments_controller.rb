class Pharmacy::PaymentsController < Pharmacy::BaseController
  def index
    @payments = current_pharmacy.payments
  end
  
  def show
    @payment = current_pharmacy.payments.find(params[:id])
    render layout: 'prescription-print'
  end
end
