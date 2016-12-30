# Preview all emails at http://localhost:3000/rails/mailers/physician_mailer
class PhysicianMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/physician_mailer/prescription_message
  def prescription_message
    PhysicianMailer.prescription_message
  end

end
