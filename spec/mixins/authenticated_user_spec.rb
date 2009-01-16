require File.dirname(__FILE__) + '/../spec_helper'

describe "Authenticated user" do

  before :all do
    @user = user.new
    @user.remember_token_expires_at.should be_nil
    @user.remember_token.should be_nil
  end

  it "should add the 'remember_token_expires_at' property to the user model" do
    @user.should respond_to(:remember_token_expires_at)
    @user.should respond_to(:remember_token_expires_at=)
  end

  it "should add the 'remember_token' property to the user model" do
    @user.should respond_to(:remember_token)
    @user.should respond_to(:remember_token=)
  end

  it "should save token and expires_at" do
    @user.remember_me
    @user.remember_token_expires_at.should_not be_nil
    @user.remember_token.should_not be_nil
  end

  it "should save expires_at as 2 weeks later" do
    @user.remember_me
    @user.remember_token_expires_at.should eql((Time.now+2.weeks).to_datetime)
  end

end


