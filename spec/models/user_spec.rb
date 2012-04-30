require 'spec_helper'

describe User do
  
  def valid_attributes
    { 
      :name => "User",
      :email => "user@example.com",
      :password => "secret",
      :password_confirmation => "secret"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create! valid_attributes
  end

  it "should require an email address" do
    no_email_user = User.new(valid_attributes.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(valid_attributes.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(valid_attributes.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create! valid_attributes
    user_with_duplicate_email = User.new valid_attributes
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = valid_attributes[:email].upcase
    User.create!(valid_attributes.merge(:email => upcased_email))
    user_with_duplicate_email = User.new valid_attributes
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "passwords" do
  
    let(:user) { Fabricate.build(:user, valid_attributes) }

    it "should have a password attribute" do
      user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      user.should respond_to(:password_confirmation)
    end

  end
  
  describe "password validations" do

    it "should require a password" do
      User.new(valid_attributes.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(valid_attributes.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = valid_attributes.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
  end
  
  describe "password encryption" do
    
    let(:user) { Fabricate(:user, valid_attributes) }
    
    it "should have an encrypted password attribute" do
      user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      user.encrypted_password.should_not be_blank
    end

  end
  
  describe "profile" do
  
    let(:user) { Fabricate.build(:user, valid_attributes) }

    it "should be created on instance creation" do
      user.profile.should be_nil
      user.save
      user.profile.should_not be_nil
    end

  end

end
