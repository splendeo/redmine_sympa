module RedmineSympa
  module Patches
    module ProjectPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          
          safe_attributes 'sympa_info'
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

        def sympa_list_type
          Setting.plugin_redmine_sympa['redmine_sympa_list_type']
        end

        # returns the xml needed for defining a mailing list
        def sympa_mailing_list_xml_def

          # Template of the generated xml:
          #
          # <?xml version='1.0'?>
          # <list>
          #   <listname>The list name</listname>
          #   <type>The list type</type>
          #   <subject>The project name</subject>
          #   <description>Project description</description>
          #   <status>open</status>
          #   <language>en_US</language>
          #   <topic>Computing</topic>
          #   <owner multiple="1">
          #     <email>email1@example.com</email>
          #   </owner>
          #   <owner multiple="1">
          #     <email>email2@example.com</email>
          #   </owner>
          # </list>

          xml = Builder::XmlMarkup.new(:indent => 2)

          xml.instruct! # adds <?xml version="1.0" encoding="UTF-8"> at the beginning
          xml.list do
            xml.listname identifier
            xml.type sympa_list_type
            xml.subject name
            xml.description description
            xml.status 'open'
            xml.language 'en_US'
            xml.topic 'Computing'
            sympa_owner_emails.each do |email|
              xml.owner('multiple' => '1') do
                xml.email(email)
              end
            end
          end

        end
      end
    end
  end
end
