module Merb
  class Authentication
    module Mixins
      module AuthenticatedUser
        module DMClassMethods
          def self.extended(base)
            base.class_eval do
              property :remember_token_expires_at, DateTime
              property :remember_token, String
            end # base.class_eval
          
          end # self.extended
        end # DMClassMethods
      end # AuthenticatedUser
    end # Mixins
  end # Authentication
end #Merb
