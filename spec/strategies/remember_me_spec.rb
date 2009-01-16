require File.dirname(__FILE__) + '/../spec_helper'

describe "Remember me strategy" do
  def do_valid_login
    put("/login", {:remember_me => "1", :pass_auth => true})
  end
  
  def do_valid_login_without_remember_me
    put("/login", {:pass_auth => true})
  end

  def do_invalid_login
    put("/login", { :pass_auth => false})
  end

  def do_home_with_auth_token
    get("/", { :pass_auth => true} ) do |controller|
      controller.request.cookies[:auth_token] = "auth_token_string"
    end
  end

  before :each do
    @user = mock(Merb::Authentication.user_class, :remember_me => true)
    user.stub!(:first).and_return(@user)
    @user.stub!(:remember_token?).and_return(true)
    @user.stub!(:remember_token).and_return(Time.now + 1.week)
    @user.stub!(:remember_token_expires_at).and_return(Time.now)
    @user.stub!(:forget_me).and_return(true)
  end

  it "should save remember_token and remember_token_expires_at if remember_me == '1'" do
    Merb::Authentication.user_class.should_receive(:first).and_return(@user)
    @user.should_receive(:remember_me)
    @user.remember_token.should_not be_nil
    @user.remember_token_expires_at.should_not be_nil
    do_valid_login.should redirect_to('/')
  end

  it "should not remember me unless remember_me == '1'" do 
    Merb::Authentication.user_class.should_receive(:first).and_return(true)
    @user.should_not_receive(:remember_me)
    do_valid_login_without_remember_me.should redirect_to('/')
  end

  it "should log in automatically if auth_token exists" do
    Merb::Authentication.user_class.should_receive(:first).and_return(@user)
    do_home_with_auth_token.should be_successful
  end

  it "should raise unauthenticated if auth_token doesn't exist" do
    lambda do
      do_invalid_login
    end.should raise_error(Merb::Controller::Unauthenticated, "Could not log in")
  end
  
  it "should clear auth_token after loging out" do
    delete('/logout') do |controller|
      controller.cookies.should_receive(:delete).with(:auth_token)
    end
  end
end


