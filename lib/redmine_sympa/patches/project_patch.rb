module RedmineSympa
  module Patches
    module ProjectPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          # This replaces the existing version of enabled_module_names with a new one
          # It is needed because we need the "destroy" callbacks to be fired,
          # and only on the erased modules (not all of them - the default implementation
          # starts by wiping them out - v0.8)
          alias_method :enabled_module_names=, :sympa_enabled_module_names=

        end
      end

      module ClassMethods
      end
        
      module InstanceMethods
        def has_sympa_mailing_list?
          return self.module_enabled?(:sympa_mailing_list)
        end

        # Redefine enabled_module_names so it invokes mod.destroy on disconnected modules
        def sympa_enabled_module_names=(module_names)
          module_names = [] unless module_names and module_names.is_a?(Array)
          module_names = module_names.collect(&:to_s)
          # remove disabled modules
          enabled_modules.each {|mod| mod.destroy unless module_names.include?(mod.name)}
          
          # detect the modules that are new, and create those only
          module_names.reject {|name| module_enabled?(name)}.each {|name| enabled_modules << EnabledModule.new(:name => name) }
        end
        
        def sympa_mailing_list_address
          "#{identifier}@#{Setting.plugin_redmine_sympa['redmine_sympa_domain']}"
        end
        
        def sympa_archive_url
          "#{Setting.plugin_redmine_sympa['redmine_sympa_archive_url']}#{identifier}"
        end

        def sympa_admin_emails
          roles = Setting.plugin_redmine_sympa['redmine_sympa_roles'].split(',').collect{|r| r.to_i}
          emails= members.all(:conditions => ['role_id IN (?)', roles]).collect{|m| m.user.mail}
          emails.push(User.find_by_admin(true).mail)
          return emails
        end
        
        # returns the xml needed for defining a mailing list
        def sympa_mailing_list_xml_def

          owners = sympa_admin_emails.collect{|m| "<owner multiple='1'><email>#{m}</email></owner>"}
          
          list_type = Setting.plugin_redmine_sympa['redmine_sympa_list_type']

          return "<?xml version='1.0' ?>
            <list>
              <listname>#{identifier}</listname>
              <type>#{list_type}</type>
              <subject>#{name}</subject>
              <description>#{description}</description>
              <status>open</status>
              <language>en_US</language>
              <topic>Computing</topic>
              #{owners.join(' ')}
            </list>"
        end
      end
    end
  end
end
