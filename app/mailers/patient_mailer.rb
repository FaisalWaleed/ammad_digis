class PatientMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.patient_mailer.verify_email.subject
  #
  def verify_email(patient, email, code)
    @code = code
    @patient = patient

    mail to: email, subject: 'Digiscripts email verification code'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.patient_mailer.email_verified.subject
  #
  def email_verified
    @greeting = "Hi"

    mail to: "to@example.org"
  end
  
  def send_prescription(prescription)
    @prescription = prescription
    @patient = @prescription.patient
    
    mail to: @patient.email_primary, subject: "Digiscripts - Prescription: #{@prescription.identifier}"
  end
  
  def send_diagnostic(diagnostic)
    @diagnostic = diagnostic
    @patient = @diagnostic.patient
    
    mail to: @patient.email_primary, subject: "Digiscripts - Lab Test: #{@diagnostic.identifier}"
  end

  def password_recovery_instructions(patient)
    @patient = patient

    mail to: @patient.email_primary, subject: "Password reset"
  end

  def password_recovery_success(patient)
    @patient = patient

    mail to: @patient.email_primary, subject: "Password reset successful"
  end

  def password_recovery_fail(patient)
    @patient = patient

    mail to: @patient.email_primary, subject: "Password reset failed"
  end
end
