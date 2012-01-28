require 'spec_helper'

describe UsersController do
  render_views
  
  #describe "GET 'new'" do
  
  #  before {get :new}

  #  it { should have_selector('h1',    text: 'Sign up') }
  #  it { should have_selector('title', text: full_title('Sign up'))}
  #end
  
  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      get :show, id: @user
    end
    
    it "should be successful" do
      response.should be_success
    end
    
    it "should find the right user" do
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      response.should have_selector("title", text: full_title(@user.name))
    end
    
    it "should include the user's name" do
      page.should have_selector("h1")
    end
    
    it "should have a profile image" do
      page.should have_selector("h1>img", class: "gravatar")
    end
  end
end
