class Physician::ProfileController < Physician::BaseController
  
  skip_before_action :require_profile
  
#   skip_before_action :require_active_subscription
  
  def edit
    @physician = current_physician
  end

  def update
    @physician = current_physician
    
    if @physician.update(physician_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to @physician.profile_newly_completed?? physician_root_url : physician_profile_edit_url
    else
      flash[:error] = "Profile update failed"
      render :action => :edit
    end
  end
  
  private 
  
  def physician_params
    params.require(:physician).permit(
      :firstname,
      :lastname,
      :middlename,
      :gender_id,
      :date_of_birth,
      :reg_num,
      :avatar,
      :signature,
      :email_primary,
      :email_secondary,
      :specialization_id,
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
      :notify_via_sms,
      :notify_via_email
    )
  end
end
