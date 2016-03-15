set :repo_url, 'git@bitbucket.org:ifoxy/zoomator.git'
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :deploy_via, :remote_cache
set :repository_cache, 'git_cache'

set :linked_files, %w(config/database.yml config/secrets.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets public/upload node_modules)
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.3'

# in case you want to set ruby version from the file:
# set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} "\
                   "RBENV_VERSION=#{fetch(:rbenv_ruby)} "\
                   "#{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all
set :keep_releases, 3
set :precompile_only_if_changed, true
set :use_sudo, false

namespace :foreman do
  desc 'Export the Procfile to Ubuntu\'s upstart scripts'
  task :export do
    on roles :app do
      execute "cd #{current_path} && (RAILS_ENV=#{fetch(:stage)} "\
        "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} "\
        "#{fetch(:rbenv_path)}/bin/rbenv sudo bundle exec foreman export "\
        "upstart /etc/init -e #{fetch(:foreman_env)} "\
        "-f #{fetch(:foreman_proc)} -a #{fetch(:app_name)} -u #{fetch(:user)} "\
        "-l #{shared_path}/log/#{fetch(:app_name)})"
    end
  end

  desc 'Start the application services'
  task :start do
    on roles :app do
      execute "sudo service #{fetch(:app_name)} start"
    end
  end

  desc 'Stop the application services'
  task :stop do
    on roles :app do
      execute "sudo service #{fetch(:app_name)} stop"
    end
  end

  desc 'Restart the application services'
  task :restart do
    on roles :app do
      execute "sudo service #{fetch(:app_name)} start || "\
        "sudo service #{fetch(:app_name)} restart"
    end
  end
end

namespace :deploy do
  after :finishing, 'deploy:cleanup'
  after :finishing, 'foreman:export'
  after :finishing, 'foreman:restart'
end
