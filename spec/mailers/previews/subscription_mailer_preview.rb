# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/payment_succeeded
  def payment_succeeded
    SubscriptionMailer.payment_succeeded
  end

  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/payment_failed
  def payment_failed
    SubscriptionMailer.payment_failed
  end

end
