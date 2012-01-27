require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {name: "Example User", email: "user@example.com"}
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

