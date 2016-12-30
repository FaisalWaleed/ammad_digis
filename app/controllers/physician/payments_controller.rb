class Physician::PaymentsController < Physician::BaseController
  
  def index
    @payments = current_physician.payments
  end

  def show
    @payment = current_physician.payments.find(params[:id])
    render layout: 'prescription-print'
  end
end
