module RedmineSympa
  module Patches
    module EnabledModulePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          after_create :sympa_enable_module
          before_destroy :sympa_disable_module
        end
      end


      module ClassMethods
      end
        
      module InstanceMethods
        def sympa_enable_module
          self.reload
          logger.warn("[REDMINE_SYMPA] #{self.project.identifier}.#{self.name} module enabled")
          if(self.name == 'sympa_mailing_list')
            logger.warn("[REDMINE_SYMPA] Project #{self.project.identifier} needs a new mailing list")
          end
        end
        
        def sympa_disable_module
          logger.warn("[REDMINE_SYMPA] #{self.project.identifier}.#{self.name} module disabled")
          if(self.name_was == 'sympa_mailing_list')
            logger.warn("[REDMINE_SYMPA] Project #{self.project.identifier} doesn't need a mailing list any more")
          end
        end
      end
    end
  end
end
