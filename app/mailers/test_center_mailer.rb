class TestCenterMailer < ApplicationMailer
  def activation_instructions(test_center)
    @test_center = test_center
    mail to: @test_center.email_primary, subject: "Activate your account"
  end
  
  def activation_welcome(test_center)
    @test_center = test_center
    mail to: @test_center.email_primary, subject: "Your account has been activated"
  end
  
  def password_recovery_instructions(test_center)
    @test_center = test_center
    mail to: @test_center.email_primary, subject: "Password reset"
  end
  
  def password_recovery_success(test_center)
    @test_center = test_center
    mail to: @test_center.email_primary, subject: "Password reset successful"
  end
  
  def password_recovery_fail(test_center)
    @test_center = test_center
    mail to: @test_center.email_primary, subject: "Password reset failed"
  end
end
