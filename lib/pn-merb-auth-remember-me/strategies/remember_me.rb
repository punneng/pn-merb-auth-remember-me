class RememberMe < Merb::Authentication::Strategy
  def run!
    login_from_cookie
  end

  def current_user
    @current_user
  end
  
  def current_user=(new_user)
    @current_user = new_user
  end
  
  # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
  # for the paranoid: we _should_ be storing user_token = hash(cookie_token, request IP)
  def login_from_cookie
    current_user = cookies[:auth_token] && Merb::Authentication.user_class.first(:conditions => ["remember_token = ?", cookies[:auth_token]])
    if current_user && current_user.remember_token?
      handle_remember_cookie! false # freshen cookie token (keeping date)
      current_user
    end
  end
  
  #
  # Remember_me Tokens
  #
  # Cookies shouldn't be allowed to persist past their freshness date,
  # and they should be changed at each login

  # Cookies shouldn't be allowed to persist past their freshness date,
  # and they should be changed at each login

  def valid_remember_cookie?
    return nil unless current_user
    (current_user.remember_token?) && 
      (cookies[:auth_token] == current_user.remember_token)
  end
  
  # Refresh the cookie auth token if it exists, create it otherwise
  def handle_remember_cookie! new_cookie_flag
    return unless current_user
    case
    when valid_remember_cookie? then current_user.refresh_token # keeping same expiry date
    when new_cookie_flag        then current_user.remember_me 
    else                             current_user.forget_me
    end
    send_remember_cookie!
  end
  
  def send_remember_cookie!
    cookies.set_cookie(:auth_token, current_user.remember_token, :expires => current_user.remember_token_expires_at.to_time)
  end


end

