module RedmineSympa
  module Patches
    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          before_save :update_password_on_all_sympa_mailing_lists
          after_destroy :unregister_from_all_sympa_mailing_lists
        end
      end

      module ClassMethods
      end
        
      module InstanceMethods

        def update_password_on_all_sympa_mailing_lists
          self.reload
          # update mailing lists if password is reset
          if(self.password)
            RedmineSympa::SympaLogger.info("User: #{self.name} has changed his password(now it is #{self.password}). It should be updated in all his mailing lists.")
          end
        end

        def unregister_from_all_sympa_mailing_lists
          RedmineSympa::SympaLogger.info("User: #{self.name} should be unregistered from all his/her mailing lists.")
        end
      end

    end
  end
end
