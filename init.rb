require 'redmine'

require 'redmine_sympa/hooks/project_hooks'

require 'dispatcher'
Dispatcher.to_prepare :redmine_sympa do
  require_dependency 'project'
  require_dependency 'enabled_module'

  Project.send(:include, RedmineSympa::Patches::ProjectPatch)
  EnabledModule.send(:include, RedmineSympa::Patches::EnabledModulePatch)

end

Redmine::Plugin.register :redmine_sympa do
  name 'Redmine Sympa plugin'
  author 'Enrique García Cota'
  description 'Integrates Redmine with Sympa mailing lists.'
  version '0.0.3'

  settings({
    :partial => 'settings/redmine_sympa',
    :default => {
      'redmine_sympa_roles' => [],
      'redmine_sympa_domain' => 'yourdomain.com',
      'redmine_sympa_archive_url' => 'http://localhost/wws/arc/',
      'redmine_sympa_path' => '/home/sympa/bin/sympa.pl',
      'redmine_sympa_log' => "#{Rails.root}/log/sympa.log",
      'redmine_sympa_list_type' => 'discussion_list'
    }
  })
  

  #project_module ensures that only the projects that have them 'active' will show them 
  project_module :sympa_mailing_list do
    #declares that our "show" from MailingList controller is public
    permission(:view_mailing_lists, {:mailing_list => [:show]}, :public => true)
  end
  
  #Creates an entry on the project menu for displaying the mailing list
  menu :project_menu, :mailing_list, { :controller => 'mailing_list', :action => 'show' }, :caption => 'Mailing List', :after => :activity, :param => :project_id
end
