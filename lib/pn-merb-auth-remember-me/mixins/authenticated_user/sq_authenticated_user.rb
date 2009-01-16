module Merb
  class Authentication
    module Mixins
      module AuthenticatedUser
        module SQClassMethods
          def self.extended(base)
            base.class_eval do

            end # base.class_eval
          
          end # self.extended
        end # SQClassMethods
        module SQInstanceMethods
        end # SQInstanceMethods
      
      end # AuthenticatedUser
    end # Mixins
  end # Authentication
end # Merb
