require 'redmine_sympa/actions'

module RedmineSympa
  module Patches
    module EnabledModulePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          after_create :sympa_enable_module
          before_destroy :sympa_disable_module
        end
      end

      module InstanceMethods
        def is_a_sympa_module?
          return (self.name == 'sympa_mailing_list' ? true : false)
        end

        def sympa_enable_module
          self.reload
          if(self.is_a_sympa_module?)
            RedmineSympa::SympaLogger.info("EnabledModule: Project #{self.project.identifier} needs a new mailing list. We must registers all its users, too.")
            RedmineSympa::Actions.create_list(project)
          end
        end

        def sympa_disable_module
          if(self.is_a_sympa_module?)
            RedmineSympa::SympaLogger.info("EnabledModule: Project #{self.project.identifier} doesn't need a mailing list any more")
            RedmineSympa::Actions.destroy_list(project)
          end
        end
      end
    end
  end
end
