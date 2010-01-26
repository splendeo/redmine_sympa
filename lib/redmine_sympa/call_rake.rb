module RedmineSympa
  module CallRake
    # stolen from http://railscasts.com/episodes/127-rake-in-background (see comments)
    def self.call_rake(task, options = {})
      options[:rails_env] ||= Rails.env
      args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
      rake_path = Setting.plugin_redmine_sympa['redmine_sympa_rake_path']
      system "#{rake_path} #{task} #{args.join(' ')} --rakefile #{Rails.root}/Rakefile >> #{Rails.root}/log/rake.log 2>&1 &"
    end
  end
end
