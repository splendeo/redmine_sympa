module RedmineSympa
  module Patches
    module ProjectPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
        end
      end

      module InstanceMethods
        def has_sympa_mailing_list?
          return self.module_enabled?(:sympa_mailing_list)
        end

        def sympa_mailing_list_address
          "#{identifier}@#{Setting.plugin_redmine_sympa['redmine_sympa_domain']}"
        end

        def sympa_admin_address
          "sympa@#{Setting.plugin_redmine_sympa['redmine_sympa_domain']}"
        end

        def sympa_archive_url
          "#{Setting.plugin_redmine_sympa['redmine_sympa_archive_url']}#{identifier}"
        end

        def sympa_url
          "#{Setting.plugin_redmine_sympa['redmine_sympa_info_url']}#{identifier}"
        end

        def sympa_owner_emails
          roles = Setting.plugin_redmine_sympa['redmine_sympa_roles'].collect{|r| r.to_i}
          emails = members.all(:conditions => ['role_id IN (?)', roles]).collect{|m| m.user.mail}
          emails << User.current.mail
          return emails.uniq
        end

        # returns the xml needed for defining a mailing list
        def sympa_mailing_list_xml_def

          owners = sympa_owner_emails.collect{|m| "<owner multiple='1'><email>#{m}</email></owner>"}

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
