

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

end



