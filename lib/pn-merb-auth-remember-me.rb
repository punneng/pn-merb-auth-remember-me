# make sure we're running inside Merb
if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  require(File.expand_path(File.dirname(__FILE__) / "pn-merb-auth-remember-me" / "mixins") / "authenticated_user")
  strategy_path = File.expand_path(File.dirname(__FILE__)) / "pn-merb-auth-remember-me" / "strategies"

  Merb::Authentication.register(:remember_me, strategy_path / "remember_me.rb")
  # require(strategy_path / "remember_me.rb")
  
  Merb::Plugins.add_rakefiles "pn-merb-auth-remember-me/merbtasks"#, "pn-merb-auth-remember-me/slicetasks", "pn-merb-auth-remember-me/spectasks"

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:pn_merb_auth_remember_me] = {
    :chickens => false
  }
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
    Merb::Authentication.after_authentication do |user,request,params|
      if params[:remember_me] == "1" 
        user.remember_me
        request.cookies.set_cookie(:auth_token, user.remember_token, :expires => user.remember_token_expires_at.to_time)
      end
      true if user 
    end
  end
  
  Merb::Plugins.add_rakefiles "pn-merb-auth-remember-me/merbtasks"
end
