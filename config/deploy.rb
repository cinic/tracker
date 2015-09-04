set :repo_url, 'git@bitbucket.org:ifoxy/zoomator.git'
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :deploy_via, :remote_cache
set :repository_cache, 'git_cache'

set :linked_files, %w(config/database.yml config/secrets.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets public/upload)

set :default_env, rvm_bin_path: '~/.rvm/bin:$PATH'
set :keep_releases, 3
set :precompile_only_if_changed, true
set :use_sudo, false
set :rvm_ruby_version, '2.2.2'

namespace :foreman do
  desc 'Export the Procfile to Ubuntu\'s upstart scripts'
  task :export do
    on roles :app do
      execute "cd #{current_path} && (RAILS_ENV=#{fetch(:stage)} "\
        '~/.rvm/bin/rvm default do rvmsudo bundle exec foreman export '\
        "upstart /etc/init -a #{fetch(:app_name)} -u #{fetch(:user)} "\
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
  # desc "Seed the database."
  # task :seed_db do
    # on roles(:app) do
      # within "#{current_path}" do
        # with rails_env: :staging do
          # execute :rake, 'db:seed'
        # end
      # end
    # end
  # end
  # desc 'Precompile assets locally and then rsync to web servers'
  # task :compile_assets do
  #   on roles(:web) do
  #     rsync_host = host.to_s

  #     run_locally do
  #       with rails_env: fetch(:stage) do ## Set your env accordingly.
  #         execute :bundle, 'exec rake assets:precompile'
  #       end
  #       execute "rsync -av --delete -e 'ssh -p 2605' ./public/assets/ "\
  #         "#{fetch(:user)}@#{rsync_host}:#{shared_path}/public/assets/"
  #       execute 'rm -rf public/assets'
  #     end
  #   end
  # end

  # node

  # desc 'Copy node upstart script'
  # task :upstart_node do
  #   on roles(:app) do
  #     within release_path do
  #       sudo :cp, "node/zoomatornode.upstart.conf", "/etc/init/zoomatornode.conf"
  #     end
  #   end
  # end

  # desc 'Restart node application'
  # task :restart_node do
  #   on roles(:app) do
  #     sudo :service, 'zoomatornode', 'restart'
  #   end
  # end

  # desc 'Install node modules'
  # task :install_node_modules do
  #   on roles(:app) do
  #     within release_path do
  #       execute "cd node && npm install -s"
  #     end
  #   end
  # end

  after :finishing, 'deploy:cleanup'
  after :finishing, 'foreman:export'
  after :finishing, 'foreman:restart'
  after :finishing, 'delayed_job:restart'

  # node

  # after :updated, :install_node_modules
  # after :updated, :upstart_node
  # after :publishing, :restart_node

  # after 'deploy:start', 'delayed_job:start'
  # after 'deploy:stop', 'delayed_job:stop'
  # after 'deploy:restart', 'delayed_job:restart'
end
