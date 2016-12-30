class TestCenter::ProfileController < TestCenter::BaseController
  skip_before_action :require_profile
  
#   skip_before_action :require_active_subscription
  
  def edit
    @test_center = current_test_center
  end
  
  def update
    @test_center = current_test_center
    
    if @test_center.update(test_center_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to @test_center.profile_newly_completed?? test_center_root_url : test_center_profile_edit_url
    else
      flash[:error] = "Profile update failed"
      render :action => :edit
    end
  end
  
  private 
  
  def test_center_params
    params.require(:test_center).permit(
      :name,
      :contact_firstname,
      :contact_lastname,
      :email_primary,
      :email_secondary,
      :avatar,
      :phone_primary,
      :phone_secondary,
      :phone_mobile,
      :phone_alternate,
      :address_street_1,
      :address_street_2,
      :address_territory,
      :address_municipality,
      :address_postal_code,
      :address_country,
      :password,
      :password_confirmation,
      :test_type_ids => []
    )
  end
end
