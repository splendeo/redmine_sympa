
require 'tempfile'

def execute_command(command)
  puts "executing command: #{command}"
  system command
end

namespace :redmine_sympa do

  desc "Create a project's mailing list, and subscribe all its users to it"
  task :create_list => :environment do
    project = Project.find(ENV["PROJECT_ID"]) or raise "PROJECT_ID missing or invalid"

    puts "creating mailing list for project #{project.identifier}"

    temp_file = Tempfile.new('list')
    temp_file.print(project.sympa_mailing_list_xml_def)
    temp_file.flush
    
    sympa_path = '/usr/lib/sympa/bin/sympa.pl'
    domain = 'testohwr.org'
    execute_command("#{sympa_path} --create_list --robot #{domain} --input_file #{temp_file.path}")
    
    STDIN.gets

  end

  desc "Destroy a project's mailing list"
  task :destroy_list => :environment do
    project = Project.find(ENV["PROJECT_ID"]) or raise "PROJECT_ID missing or invalid"
    
    puts "destroying mailing list for project #{project.identifier}"

    domain = 'testohwr.org'
    sympa_path = '/usr/lib/sympa/bin/sympa.pl'
    execute_command("#{sympa_path} --close_list=#{project.identifier}@#{domain}")
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



