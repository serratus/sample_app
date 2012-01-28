require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      name: "Example User", 
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"}
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(name: ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge(email: ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    too_long_user = User.new(@attr.merge(name: "a"*51))
    too_long_user.should_not be_valid
  end
  
  
  it "should accept valid email addresses" do
    valid = %w[user@foo.com ZitronenMelisse@gmx.at ch.oberhofer@gmail.com]
    valid.each do |address|
      valid_email_user = User.new(@attr.merge(email: address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    invalid = %w[user@foo,com Zitmel.gmx.at ch.oberhofer@gmail]
    invalid.each do |address|
      invalid_email_user = User.new(@attr.merge(email: address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(email: upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(password: "", password_confirmation: "")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(password_confirmation: "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      pass = "a"*5
      User.new(@attr.merge(password: pass, password_confirmation: pass)).
        should_not be_valid
    end
    
    it "should reject long passwords" do
      pass = "a"*41
      User.new(@attr.merge(password: pass, password_confirmation: pass)).
        should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      it "should be true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should be nil on username/password missmatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      
      it "should be nil on emailaddress with no user existent" do
        nonexistent_user = User.authenticate("foo@gmx.at", @attr[:password])
        nonexistent_user.should be_nil
      end
      
      it "should return the user on email/password match" do
        user = User.authenticate(@attr[:email], @attr[:password])
        user.should == @user
      end
    end
    
  end
  
end
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

