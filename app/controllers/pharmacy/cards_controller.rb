class Pharmacy::CardsController < Pharmacy::BaseController
  
  include ::CardsController
  
  private
  
  def load_current_customer
    @customer = current_pharmacy
  end
end
