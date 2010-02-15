class MailingListController < ApplicationController
  unloadable
  
  before_filter :find_project, :authorize, :only => [:show]

  def show
    
  end
  
  private

  def find_project
    # @project variable must be set before calling the authorize filter
    
    
    @sympa_address = "sympa@#{Setting.plugin_redmine_sympa['redmine_sympa_domain']}"
    
    @project = Project.find(params[:project_id])
  end

end
