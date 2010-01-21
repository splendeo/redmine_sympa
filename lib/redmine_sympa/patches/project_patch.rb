module RedmineSympa
  module Patches
    module ProjectPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          #alias_method :old_enabled_module_names=, :enabled_module_names=
          alias_method :enabled_module_names=, :sympa_enabled_module_names=


          after_save :update_sympa_mailing_list
          after_destroy :destroy_sympa_mailing_list
        end
      end

      module ClassMethods
      end
        
      module InstanceMethods

        # Redefine enabled_module_names so it invokes mod.destroy on disconnected modules
        def sympa_enabled_module_names=(module_names)

          module_names = [] unless module_names and module_names.is_a?(Array)
          module_names = module_names.collect(&:to_s)
          # remove disabled modules
          enabled_modules.each {|mod| mod.destroy unless module_names.include?(mod.name)}
          
          # detect the modules that are new
          new_module_names = module_names.reject {|name| module_enabled?(name)}
          
          logger.warn("[REDMINE_SYMPA] Project #{self.identifier} new modules: #{new_module_names}")
          
          # create the new modules only
          new_module_names.each {|name| enabled_modules << EnabledModule.new(:name => name) }
        end

        # This should log something when the project is saved
        def update_sympa_mailing_list
          self.reload
          logger.warn("[REDMINE_SYMPA] Project #{self.identifier} updated")
        end

        def destroy_sympa_mailing_list
          logger.warn("[REDMINE_SYMPA] Project #{self.identifier} deleted")
        end
      end
    end
  end
end
