### PnMerbAuthRememberMe

This plugin provides a remember me function based on MerbAuth. Most of codes are from [Remember me's RestfulAuthentication on Rails](http://github.com/technoweenie/restful-authentication/tree/master)  

This plugin adds a mixin that you should include in your user model to provide 2 fields to remember the token and time to expire. The mixin will automatically select the correct sub mixin for all supported orms.  
 
<pre><code>  class User
  include DataMapper::Resource
  include Merb::Authentication::Mixins::AuthenticatedUser

  property :id,    Serial
end
</code></pre>

### Migration Requirements

The mixin requires some fields to be in-place on your model.  Where needed include these in your migrations.  
<pre><code>  :remember_token_expires_at, DateTime
  :remember_token, String
</code></pre>

### Configuration Options

declare in your _merb/merb-auth/strategies.rb_ file  

    Merb::Authentication.activate!(:remember_me) 
    

------------------------------------------------------------------------------  

Instructions for installation:

Rake tasks to package/install the gem - edit this to modify the manifest.  

file: config/dependencies.rb

\# add the plugin as a regular dependency

    dependency 'pn-merb-auth-remember-me'

file: slice/merb-auth-slice-password/app/controllers/sessions.rb or the logout action  

\# clear :auth\_token after log out

    cookies.delete :auth\_token

