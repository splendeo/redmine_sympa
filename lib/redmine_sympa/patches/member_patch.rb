module RedmineSympa
  module Patches
    module MemberPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          after_create :register_on_sympa_mailing_list
          after_destroy :unregister_from_sympa_mailing_list
        end
      end

      module ClassMethods
      end
        
      module InstanceMethods
      
        def has_sympa_mailing_list?
          return project.has_sympa_mailing_list?
        end

        def register_on_sympa_mailing_list
          self.reload

          if(self.has_sympa_mailing_list?)
            RedmineSympa::SympaLogger.info("Member: User #{self.user.name} is now member of project #{self.project.identifier}. We must register him on its mailing list.")
          end
        end

        def unregister_from_sympa_mailing_list
          if(self.has_sympa_mailing_list?)
            RedmineSympa::SympaLogger.info("Member: User #{self.user.name} should be unregistered from project #{self.project.identifier}'s mailing list.")
          end
        end
      end

    end
  end
end
