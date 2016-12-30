# Preview all emails at http://localhost:3000/rails/mailers/patient_mailer
class PatientMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/patient_mailer/verify_email
  def verify_email
    PatientMailer.verify_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/patient_mailer/email_verified
  def email_verified
    PatientMailer.email_verified
  end

end
