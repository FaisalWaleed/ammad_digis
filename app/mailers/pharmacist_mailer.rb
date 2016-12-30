class PharmacistMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pharmacist_mailer.activation_instructions.subject
  #
  def activation_instructions(pharmacist)
    @pharmacist = pharmacist

    mail to: @pharmacist.email_primary, subject: "Activate your account"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pharmacist_mailer.activation_welcome.subject
  #
  def activation_welcome(pharmacist)
    @pharmacist = pharmacist

    mail to: @pharmacist.email_primary, subject: "Your account has been activated"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pharmacist_mailer.password_recovery_instructions.subject
  #
  def password_recovery_instructions(pharmacist)
    @pharmacist = pharmacist

    mail to: @pharmacist.email_primary, subject: "Password reset"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pharmacist_mailer.password_recovery_success.subject
  #
  def password_recovery_success(pharmacist)
    @pharmacist = pharmacist

    mail to: @pharmacist.email_primary, subject: "Password reset successful"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pharmacist_mailer.password_recovery_fail.subject
  #
  def password_recovery_fail(pharmacist)
    @pharmacist = pharmacist

    mail to: @pharmacist.email_primary, subject: "Password reset failed"
  end
end
