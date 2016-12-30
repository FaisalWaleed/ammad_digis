require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "payment_succeeded" do
    let(:mail) { SubscriptionMailer.payment_succeeded }

    it "renders the headers" do
      expect(mail.subject).to eq("Payment succeeded")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "payment_failed" do
    let(:mail) { SubscriptionMailer.payment_failed }

    it "renders the headers" do
      expect(mail.subject).to eq("Payment failed")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
