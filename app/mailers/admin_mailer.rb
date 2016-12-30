class AdminMailer < ApplicationMailer
  
  def activation_instructions(admin)
    @admin = admin
    
    mail to: @admin.email, subject: "Activate your account"
  end
  
  def activation_welcome(admin)
    @admin = admin
    
    mail to: @admin.email, subject: "Your account has been activated"
  end
  
  def password_recovery_instructions(admin)
    @admin = admin
    
    mail to: @admin.email, subject: "Password reset"
  end
  
  def password_recovery_success(admin)
    @admin = admin
    
    mail to: @admin.email, subject: "Password reset successful"
  end
  
  def password_recovery_fail(admin)
    @admin = admin
    
    mail to: @admin.email, subject: "Password reset failed"
  end
end
