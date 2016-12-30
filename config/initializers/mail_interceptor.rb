class DevelopmentMailInterceptor
  def self.delivering_email(msg)
    msg.subject = "#{msg.to} #{msg.subject}"
    msg.to = Rails.application.secrets.email_intercept_address || "omar@onegreatstudio.com"
  end
end

ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

