class TestCenter::CardsController < TestCenter::BaseController
  
  include ::CardsController
  
  private
  
  def load_current_customer
    @customer = current_test_center
  end
end
