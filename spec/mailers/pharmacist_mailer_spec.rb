require "rails_helper"

RSpec.describe PharmacistMailer, type: :mailer do
  describe "activation_instructions" do
    let(:mail) { PharmacistMailer.activation_instructions }

    it "renders the headers" do
      expect(mail.subject).to eq("Activation instructions")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "activation_welcome" do
    let(:mail) { PharmacistMailer.activation_welcome }

    it "renders the headers" do
      expect(mail.subject).to eq("Activation welcome")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "password_recovery_instructions" do
    let(:mail) { PharmacistMailer.password_recovery_instructions }

    it "renders the headers" do
      expect(mail.subject).to eq("Password recovery instructions")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "password_recovery_success" do
    let(:mail) { PharmacistMailer.password_recovery_success }

    it "renders the headers" do
      expect(mail.subject).to eq("Password recovery success")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "password_recovery_fail" do
    let(:mail) { PharmacistMailer.password_recovery_fail }

    it "renders the headers" do
      expect(mail.subject).to eq("Password recovery fail")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
