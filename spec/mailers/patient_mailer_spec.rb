require "rails_helper"

RSpec.describe PatientMailer, type: :mailer do
  describe "verify_email" do
    let(:mail) { PatientMailer.verify_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Verify email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "email_verified" do
    let(:mail) { PatientMailer.email_verified }

    it "renders the headers" do
      expect(mail.subject).to eq("Email verified")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
