module RedmineSympa
  module Hooks
    class ProjectHooks < Redmine::Hook::ViewListener
      # :project
      # :form
      def view_projects_form(context={})
        content = context[:form].text_area(:sympa_info, :rows => 5, :class => 'wiki-edit') + wikitoolbar_for('project_sympa_info')
        return content_tag(:p, content)
      end
    end
  end
end
