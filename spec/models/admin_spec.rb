require 'spec_helper'

describe Admin do
  
  def valid_attributes
    { 
      :email => "admin@example.com",
      :password => "admin"
    }
  end

  it "should create a new instance given valid attributes" do
    Admin.create! valid_attributes
  end

  it "should require an email address" do
    no_email_admin = Admin.new(valid_attributes.merge(:email => ""))
    no_email_admin.should_not be_valid
  end
  
  describe "passwords" do
    let(:admin) { Fabricate.build(:admin, valid_attributes) }

    it "should have a password attribute" do
      admin.should respond_to(:password)
    end
  end
  
  describe "password validations" do
    it "should require a password" do
      Admin.new(valid_attributes.merge(:password => "")).should_not be_valid
    end
  end
  
  describe "password encryption" do
    let(:admin) { Fabricate(:admin, valid_attributes) }
    
    it "should have an encrypted password attribute" do
      admin.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      admin.encrypted_password.should_not be_blank
    end
  end

end
