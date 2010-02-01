require 'tempfile'
require 'redmine_sympa/sympa_logger'

module RedmineSympa
  module Actions
    def self.execute_command(command)
      RedmineSympa::SympaLogger.info("  executing #{command}")
      system "#{command} >> #{RedmineSympa::SympaLogger.path} 2>&1 &"
    end

    def self.get_sympa_path
      Setting.plugin_redmine_sympa['redmine_sympa_path']
    end

    def self.get_domain
      Setting.plugin_redmine_sympa['redmine_sympa_domain']
    end

    def self.create_list(project)
      temp_file = Tempfile.new('list')
      temp_file.print(project.sympa_mailing_list_xml_def)
      temp_file.flush
      RedmineSympa::SympaLogger.info "Creating mailing list for project #{project.identifier}"
      execute_command("#{get_sympa_path} --create_list --robot #{get_domain} --input_file #{temp_file.path}")
    end
    
    def self.destroy_list(project)
      RedmineSympa::SympaLogger.info "Destroying mailing list for project #{project.identifier}"
      execute_command("#{get_sympa_path} --close_list=#{project.identifier}@#{get_domain}")
    end
  end
end

