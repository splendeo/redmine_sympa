
require 'tempfile'

def execute_command(command)
  puts "executing command: #{command}"
  system command
end

def get_sympa_path
  Setting.plugin_redmine_sympa['redmine_sympa_path']
end

def get_domain
  Setting.plugin_redmine_sympa['redmine_sympa_domain']
end

namespace :redmine_sympa do

  desc "Create a project's mailing list, and subscribe all its users to it"
  task :create_list => :environment do
    project = Project.find(ENV["PROJECT_ID"]) or raise "PROJECT_ID missing or invalid"

    puts "creating mailing list for project #{project.identifier}"

    temp_file = Tempfile.new('list')
    temp_file.print(project.sympa_mailing_list_xml_def)
    temp_file.flush

    execute_command("#{get_sympa_path} --create_list --robot #{get_domain} --input_file #{temp_file.path}")

    STDIN.gets

  end

  desc "Destroy a project's mailing list"
  task :destroy_list => :environment do
    project = Project.find(ENV["PROJECT_ID"]) or raise "PROJECT_ID missing or invalid"
    
    puts "destroying mailing list for project #{project.identifier}"

    execute_command("#{get_sympa_path} --close_list=#{project.identifier}@#{get_domain}")
  end

  desc "Subscribes user to a project's mailing list"
  task :subscribe => :environment do
    project = Project.find(ENV["PROJECT_ID"]) or raise "PROJECT_ID missing or invalid"
    user = User.find(ENV["USER_ID"]) or raise "USER_ID missing or invalid"
    
    puts "Subscribing user #{user.name} to list of project #{project.identifier}"
  end

  desc "Unsubscribes a user from a mailing list"
  task :unsubscribe => :environment do
    project = Project.find(ENV["PROJECT_ID"])
    user = User.find(ENV["USER_ID"]) or raise "USER_ID missing or invalid"
    
    puts "Unsubscribing user #{user.name} from list of project #{project.identifier}"
  end

  desc "Unsubscribes a user from all his/her lists"
  task :unsubscribe_from_all => :envionment do
    user = User.find(ENV["USER_ID"]) or raise "USER_ID missing or invalid"
    
    puts "Unsubscribing user #{user.name} from all his/her lists"
  end

  desc "Resets a user's password on all his/her mailing lists"
  task :reset_password => :environment do
    user = User.find(ENV["USER_ID"]) or raise "USER_ID missing or invalid"
    password = ENV["PASSWORD"] or raise "PASSWORD needed"
    
    puts "Resetting password of user #{user.name} to #{password}"
  end

end



