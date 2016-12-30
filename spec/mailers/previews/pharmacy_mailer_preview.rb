# Preview all emails at http://localhost:3000/rails/mailers/pharmacy_mailer
class PharmacyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/pharmacy_mailer/activation_instructions
  def activation_instructions
    PharmacyMailer.activation_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/pharmacy_mailer/activation_welcome
  def activation_welcome
    PharmacyMailer.activation_welcome
  end

  # Preview this email at http://localhost:3000/rails/mailers/pharmacy_mailer/password_recovery_instructions
  def password_recovery_instructions
    PharmacyMailer.password_recovery_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/pharmacy_mailer/password_recovery_success
  def password_recovery_success
    PharmacyMailer.password_recovery_success
  end

  # Preview this email at http://localhost:3000/rails/mailers/pharmacy_mailer/password_recovery_fail
  def password_recovery_fail
    PharmacyMailer.password_recovery_fail
  end

end
