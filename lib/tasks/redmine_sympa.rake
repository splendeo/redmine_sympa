

namespace :redmine_sympa do


  desc "Create a project's mailing list, and subscribe all its users to it"
  task :create_list => :environment do
    require 'redmine_sympa/actions.rb'

    project = Project.find(ENV["PROJECT_ID"]) or raise "PROJECT_ID missing or invalid"

    puts "Creating mailing list for project #{project.identifier}"
    RedmineSympa::SympaLogger.info("Rake: create_list")
    RedmineSympa::Actions.create_list(project)

  end

  desc "Destroy a project's mailing list"
  task :destroy_list => :environment do
    require 'redmine_sympa/actions.rb'

    project = Project.find(ENV["PROJECT_ID"]) or raise "PROJECT_ID missing or invalid"

    puts "Destroying mailing list for project #{project.identifier}"
    RedmineSympa::SympaLogger.info("Rake: destroy_list")
    RedmineSympa::Actions.destroy_list(project)
  end

  desc "Subscribes user to a project's mailing list"
  task :subscribe => :environment do
    require 'redmine_sympa/actions.rb'

    project = Project.find(ENV["PROJECT_ID"]) or raise "PROJECT_ID missing or invalid"
    user = User.find(ENV["USER_ID"]) or raise "USER_ID missing or invalid"

    puts "Subscribing user #{user.name} to list of project #{project.identifier}"
    RedmineSympa::SympaLogger.info("Rake: subscribe")
    RedmineSympa::Actions.subscribe(project, user)
  end

  desc "Unsubscribes a user from a mailing list"
  task :unsubscribe => :environment do
    require 'redmine_sympa/actions.rb'

    project = Project.find(ENV["PROJECT_ID"])
    user = User.find(ENV["USER_ID"]) or raise "USER_ID missing or invalid"
    
    puts "Unsubscribing user #{user.name} from list of project #{project.identifier}"
    RedmineSympa::SympaLogger.info("Rake: unsubscribe")
    RedmineSympa::Actions.unsubscribe(project, user)
  end

  desc "Unsubscribes a user from all his/her lists"
  task :unsubscribe_from_all => :envionment do
    require 'redmine_sympa/actions.rb'

    user = User.find(ENV["USER_ID"]) or raise "USER_ID missing or invalid"
    
    puts "Unsubscribing user #{user.name} from all his/her lists"
    RedmineSympa::SympaLogger.info("Rake: unsubscribe_from_all")
    RedmineSympa::Actions.unsubscribe_from_all(user)
  end

  desc "Resets a user's password on all his/her mailing lists"
  task :reset_password => :environment do
    require 'redmine_sympa/actions.rb'

    user = User.find(ENV["USER_ID"]) or raise "USER_ID missing or invalid"
    password = ENV["PASSWORD"] or raise "PASSWORD needed"

    puts "Resetting password of user #{user.name} to #{password}"
    RedmineSympa::SympaLogger.info("Rake: reset_password")
    RedmineSympa::Actions.reset_password(user, password)
  end
  
  desc "Clears the log file"
  task :clear_log => :environment do
    require 'redmine_sympa/sympa_logger.rb'
    RedmineSympa::SympaLogger.clear
  end

end



