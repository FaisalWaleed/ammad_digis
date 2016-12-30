class Pharmacist::ProfileController < Pharmacist::BaseController
  skip_before_action :require_profile
  skip_before_action :require_active_subscription
  
  def edit
    @pharmacist = current_pharmacist
  end

  def update
    if current_pharmacist.update(pharmacist_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to pharmacist_profile_edit_url
    else
      flash[:error] = "Profile update failed"
      render :action => :edit
    end
  end
  
  private 
  
  def pharmacist_params
    params.require(:pharmacist).permit(
      :firstname,
      :lastname,
      :middlename,
      :gender_id,
      :email_primary,
      :email_secondary,
      :reg_num,
      :avatar,
      :login,
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
