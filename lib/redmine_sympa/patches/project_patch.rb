module RedmineSympa
  module Patches
    module ProjectPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
        base.class_eval do
          #unloadable # Send unloadable so it will not be unloaded in development
 
          after_save :update_sympa_mailing_list
          after_destroy :destroy_sympa_mailing_list
        end
      end
 
 
      module ClassMethods
      end
        
      module InstanceMethods
        # This should log something when the project is saved
        def update_sympa_mailing_list
          logger.warn('[REDMINE_SYMPA] In update_sympa_mailing_list')
          self.reload
          
          if(self.module_enabled?(:sympa_mailing_list) != nil)
            logger.warn('[REDMINE_SYMPA] I should try to create the sympa mailing list now, if it did not exist')
          else
            self.destroy_sympa_mailing_list
          end
          
          return true
        end
   
        def destroy_sympa_mailing_list
          logger.warn('[REDMINE_SYMPA] In destroy_sympa_mailing_list')
        end
      end
    end
  end
end
