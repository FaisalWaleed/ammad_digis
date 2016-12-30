class SubscriptionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.payment_succeeded.subject
  #
  def payment_succeeded(subscription, payment)
    @subscription = subscription
    @payment = payment
    @subscriber = subscription.subscriber

    mail to: @subscriber.email_primary, subject: "Your subscription payment was received."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.payment_failed.subject
  #
  def payment_failed(subscription, payment)
    @subscription = subscription
    @payment = payment
    @subscriber = subscription.subscriber
    
    mail to: @subscriber.email_primary, subject: "Your subscription payment failed."
  end
  
  def cancelled(subscription)
    @subscription = subscription
    @subscriber = subscription.subscriber
    
    mail to: @subscriber.email_primary, subject: "Your subscription has been cancelled."
  end
  
  def trial_will_end(subscription, trial_start, trial_end)
    @subscription = subscription
    @subscriber = subscription.subscriber
    @trial_start = trial_start
    @trial_end = trial_end
    
    mail to: @subscriber.email_primary, subject: "Your trial period will end soon."
  end
end
