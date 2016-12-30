# Preview all emails at http://localhost:3000/rails/mailers/pharmacist_mailer
class PharmacistMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/pharmacist_mailer/activation_instructions
  def activation_instructions
    PharmacistMailer.activation_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/pharmacist_mailer/activation_welcome
  def activation_welcome
    PharmacistMailer.activation_welcome
  end

  # Preview this email at http://localhost:3000/rails/mailers/pharmacist_mailer/password_recovery_instructions
  def password_recovery_instructions
    PharmacistMailer.password_recovery_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/pharmacist_mailer/password_recovery_success
  def password_recovery_success
    PharmacistMailer.password_recovery_success
  end

  # Preview this email at http://localhost:3000/rails/mailers/pharmacist_mailer/password_recovery_fail
  def password_recovery_fail
    PharmacistMailer.password_recovery_fail
  end

end
