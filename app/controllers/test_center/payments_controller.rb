class TestCenter::PaymentsController < TestCenter::BaseController
  def index
    @payments = current_test_center.payments
  end
  
  def show
    @payment = current_test_center.payments.find(params[:id])
    render layout: 'prescription-print'
  end
end
