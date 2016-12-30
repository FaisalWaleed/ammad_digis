class Pharmacy::ProfileController < Pharmacy::BaseController
  skip_before_action :require_profile
  
  def edit
    @pharmacy = current_pharmacy
  end

  def update
    @pharmacy = current_pharmacy
    
    if @pharmacy.update(pharmacy_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to @pharmacy.profile_newly_completed?? pharmacy_root_url : pharmacy_profile_edit_url
    else
      flash[:error] = "Profile update failed"
      render :action => :edit
    end
  end
  
  private 
  
  def pharmacy_params
    params.require(:pharmacy).permit(
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
      :password_confirmation
    )
  end
end
