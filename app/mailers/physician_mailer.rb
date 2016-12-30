class PhysicianMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.physician_mailer.prescription_message.subject
  #
  def prescription_message(physician, message)
    @message = message
    @physician = physician
    @pharmacist = @message.sender
    @prescription = @message.asset
    @pharmacy = @prescription.pharmacy

    mail to: physician.email_primary, subject: "#{@pharmacist.name} at #{@pharmacy.name} has sent you a message via Digiscripts"
  end
  
  def activation_instructions(physician)
    @physician = physician

    mail to: @physician.email_primary, subject: "Activate your account"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.physician_mailer.activation_welcome.subject
  #
  def activation_welcome(physician)
    @physician = physician

    mail to: @physician.email_primary, subject: "Your account has been activated"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.physician_mailer.password_recovery_instructions.subject
  #
  def password_recovery_instructions(physician)
    @physician = physician

    mail to: @physician.email_primary, subject: "Password reset"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.physician_mailer.password_recovery_success.subject
  #
  def password_recovery_success(physician)
    @physician = physician

    mail to: @physician.email_primary, subject: "Password reset successful"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.physician_mailer.password_recovery_fail.subject
  #
  def password_recovery_fail(physician)
    @physician = physician

    mail to: @physician.email_primary, subject: "Password reset failed"
  end
  
  def test_result_requires_review(test_result)
    @test_result = test_result
    @physician = test_result.physician
    
    mail to: @physician.email_primary, subject: "Test Result requires review"
  end
end
