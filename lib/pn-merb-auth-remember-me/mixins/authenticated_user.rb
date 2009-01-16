require "digest/sha1"
module Merb
  class Authentication
    module Mixins
      # This mixin provides basic user remember token.
      #
      # Added properties:
      #  :remember_token_expires_at, DateTime
      #  :remember_token, String
      #
      # To use it simply require it and include it into your user class.
      #
      # class User
      #   include Merb::Authentication::Mixins::AuthenticatedUser
      #
      # end
      #
      module AuthenticatedUser
        def self.included(base)
          base.class_eval do
            include Merb::Authentication::Mixins::AuthenticatedUser::InstanceMethods
            extend  Merb::Authentication::Mixins::AuthenticatedUser::ClassMethods

            path = File.expand_path(File.dirname(__FILE__)) / "authenticated_user"
            if defined?(DataMapper) && DataMapper::Resource > self
              require path / "dm_authenticated_user"
              extend(Merb::Authentication::Mixins::AuthenticatedUser::DMClassMethods)
            elsif defined?(ActiveRecord) && ancestors.include?(ActiveRecord::Base)
              require path / "ar_authenticated_user"
              extend(Merb::Authentication::Mixins::AuthenticatedUser::ARClassMethods)
            elsif defined?(Sequel) && ancestors.include?(Sequel::Model)
              require path / "sq_authenticated_user"
              extend(Merb::Authentication::Mixins::AuthenticatedUser::SQClassMethods)
            end

          end # base.class_eval
        end # self.included


        module ClassMethods
          def secure_digest(*args)
            Digest::SHA1.hexdigest(args.flatten.join('--'))
          end

          # Create random key.
          #
          # ==== Returns
          # String:: The generated key
          def make_token
            secure_digest(Time.now, (1..10).map{ rand.to_s })
          end 
        end # ClassMethods

        module InstanceMethods
          def remember_token?
            (!remember_token.blank?) && 
              remember_token_expires_at && (Time.now.utc < remember_token_expires_at.utc)
          end

          # These create and unset the fields required for remembering users between browser closes
          def remember_me(time = 2.weeks)
            remember_me_for time
          end

          def remember_me_for(time)
            remember_me_until time.from_now.utc
          end

          def remember_me_until(time)
            self.remember_token_expires_at = time
            self.remember_token            = self.class.make_token
            save
          end

          # refresh token (keeping same expires_at) if it exists
          def refresh_token
            if remember_token?
              self.remember_token = self.class.make_token 
              save
            end
          end

          # 
          # Deletes the server-side record of the authentication token.  The
          # client-side (browser cookie) and server-side (this remember_token) must
          # always be deleted together.
          #
          def forget_me
            self.remember_token_expires_at = nil
            self.remember_token            = nil
            save
          end
        end # InstanceMethods
      end # AuthenticatedUser
    end # Mixins
  end # Authentication
end # Merb
