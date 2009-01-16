$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'activesupport'
require 'merb-core'
require 'dm-core'
require 'do_sqlite3'
require 'merb-auth-core'
require 'merb-auth-more'
require 'merb-auth-more/mixins/redirect_back'
require 'spec'
require 'pn-merb-auth-remember-me'

Merb.start_environment(
  :testing => true, 
  :adapter => 'runner', 
  :environment => ENV['MERB_ENV'] || 'test',
#  :merb_root => Merb.root,
  :session_store => :cookie,
  :exception_details => true,
  :session_secret_key => "d3a6d6f99a25004dd82b71af8bded0ab71d3ea21"
  
)

DataMapper.setup(:default, "sqlite3::memory:")
    
class User
  include DataMapper::Resource
  include Merb::Authentication::Mixins::AuthenticatedUser

  property :id, Serial
  property :email, String
  property :login, String
end

Merb::Authentication.user_class = User
def user
  Merb::Authentication.user_class
end


# for strategy 
Merb::Config[:exception_details] = true
Merb::Router.reset!
Merb::Router.prepare do
  match("/login", :method => :get).to(:controller => "exceptions", :action => "unauthenticated").name(:login)
  match("/login", :method => :put).to(:controller => "sessions", :action => "update")
  
  authenticate do
    match("/").to(:controller => "my_controller")
  end
  match("/logout", :method => :delete).to(:controller => "sessions", :action => "destroy")
end

class Merb::Authentication
  def store_user(user); user; end
  def fetch_user(session_info); session_info; end
end

Merb::Authentication.activate!(:remember_me)
Merb::Authentication.activate!(:default_password_form)

class MockUserStrategy < Merb::Authentication::Strategy
  def run!
    params[:pass_auth] = if params[:pass_auth] == "false"
      false 
    else
      Merb::Authentication.user_class.first
    end
    params[:pass_auth]
  end
end

class Application < Merb::Controller; end

class Sessions < Merb::Controller
  before :ensure_authenticated
  def update
    redirect "/"
  end
  
  def destroy
    cookies.delete :auth_token
    session.abandon!
  end      
end

class MyController < Application
  def index
    "IN MY CONTROLLER"
  end
end

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
  config.before(:all){ User.auto_migrate! }
  config.after(:all){ User.all.destroy! }
end

