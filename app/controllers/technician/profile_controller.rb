class Technician::ProfileController < Technician::BaseController
  skip_before_action :require_profile
  skip_before_action :require_active_subscription
  
  def edit
    @technician = current_technician
  end
  
  def update
    @technician = current_technician

    if current_technician.update(technician_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to technician_profile_edit_url
    else
      flash[:error] = "Profile update failed"
      render :action => :edit
    end
  end
  
  private 
  
  def technician_params
    params.require(:technician).permit(
      :firstname,
      :lastname,
      :middlename,
      :gender_id,
      :email_primary,
      :email_secondary,
      :reg_num,
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
