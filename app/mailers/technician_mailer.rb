class TechnicianMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.technician_mailer.activation_instructions.subject
  #
  def activation_instructions(technician)
    @technician = technician

    mail to: @technician.email_primary, subject: "Activate your account"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.technician_mailer.activation_welcome.subject
  #
  def activation_welcome(technician)
    @technician = technician

    mail to: @technician.email_primary, subject: "Your account has been activated"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.technician_mailer.password_recovery_instructions.subject
  #
  def password_recovery_instructions(technician)
    @technician = technician

    mail to: @technician.email_primary, subject: "Password reset"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.technician_mailer.password_recovery_success.subject
  #
  def password_recovery_success(technician)
    @technician = technician

    mail to: @technician.email_primary, subject: "Password reset successful"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.technician_mailer.password_recovery_fail.subject
  #
  def password_recovery_fail(technician)
    @technician = technician

    mail to: @technician.email_primary, subject: "Password reset failed"
  end
end
