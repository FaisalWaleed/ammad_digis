class Physician::CardsController < Physician::BaseController
  
  include ::CardsController
  
  private
  
  def load_current_customer
    @customer = current_physician
  end
end
