class PharmacyMailer < ApplicationMailer
  def activation_instructions(pharmacy)
    @pharmacy = pharmacy
    mail to: @pharmacy.email_primary, subject: "Activate your account"
  end
  
  def activation_welcome(pharmacy)
    @pharmacy = pharmacy
    mail to: @pharmacy.email_primary, subject: "Your account has been activated"
  end

  def password_recovery_instructions(pharmacy)
    @pharmacy = pharmacy
    mail to: @pharmacy.email_primary, subject: "Password reset"
  end

  def password_recovery_success(pharmacy)
    @pharmacy = pharmacy
    mail to: @pharmacy.email_primary, subject: "Password reset successful"
  end

  def password_recovery_fail(pharmacy)
    @pharmacy = pharmacy
    mail to: @pharmacy.email_primary, subject: "Password reset failed"
  end
end
