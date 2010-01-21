require 'redmine'
 
#require 'join_project/hooks/layout_hooks'
#require 'join_project/hooks/project_hooks'
#require 'join_project/hooks/my_hooks'
 
require 'dispatcher'
Dispatcher.to_prepare :redmine_sympa do
  require_dependency 'project'
  require_dependency 'enabled_module'
  
  Project.send(:include, RedmineSympa::Patches::ProjectPatch)
  EnabledModule.send(:include, RedmineSympa::Patches::EnabledModulePatch)
  
  # Remove the load the observer so it's registered for each request.
  #ActiveRecord::Base.observers.delete(:project_join_request_observer)
  #ActiveRecord::Base.observers << :project_join_request_observer
end

Redmine::Plugin.register :redmine_sympa do
  name 'Redmine Sympa plugin'
  author 'Enrique García Cota'
  description 'Integrates Redmine with Sympa mailing lists.'
  version '0.0.1'

  #project_module ensures that only the projects that have them 'active' will show them 
  project_module :sympa_mailing_list do
    #declares that our "show" from MailingList controller is public
    permission(:view_mailing_lists, {:mailing_list => [:show]}, :public => true)
  end
  
  #Creates an entry on the project menu for displaying the mailing list
  menu :project_menu, :mailing_list, { :controller => 'mailing_list', :action => 'show' }, :caption => 'Mailing List', :after => :activity, :param => :project_id
end
