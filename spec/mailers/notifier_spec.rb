require "spec_helper"

describe Notifier do
  describe "contacted" do
    let(:message) {{ name: "user", email: "user@example.com", :subject => "foo", body: "bar" }}
    let(:cf)      { ContactForm.new(message) }
    let(:mail)    { Notifier.contacted(cf) }

    it "renders the headers" do
      # mail.subject.should eq("[pickingwords-contact] #{message[:subject]}")
      # mail.to.should eq([ENV["CONTACT_EMAIL"]])
      # mail.from.should eq([message[:email]])
      pending "green but based on env variable"
    end

    it "renders the body" do
      mail.body.encoded.should match(message[:body])
    end
  end
end
