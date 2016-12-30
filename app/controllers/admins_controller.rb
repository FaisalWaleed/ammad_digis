class AdminsController < ApplicationController
  layout 'admin/session'
  
  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      flash.now[:notice] = "Administrator registered!"
      redirect_back_or_default admin_root_url
    else
      flash.now[:error] = "Administrator was not saved!"
      render :action => :new
    end
  end
  
  private
  
  def admin_params
    params.require(:admin).permit(
      :email,
      :password,
      :password_confirmation,
      :superadmin
      )
  end
end
