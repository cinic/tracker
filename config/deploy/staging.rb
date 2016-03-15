set :stage, :staging
set :deploy_to, '/home/deployer/zoomator/staging'
set :app_name, 'zoomator'
set :user, 'deployer'
set :branch, 'development'
# set :rails_env, 'staging' #added for delayed job
set :delayed_job_command, 'bin/delayed_job'
set :delayed_job_args, '--queues=packets,intervals'
set :foreman_env, '.env.staging'
set :foreman_proc, 'Procfile.staging'

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, %w{178.62.167.92}
role :web, %w{178.62.167.92}
role :db,  %w{178.62.167.92}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '178.62.167.92', user: 'deployer', roles: %w{web app db}, primary: :true

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
set :ssh_options, {
  user: 'deployer',
  keys: %w(~/.ssh/id_rsa),
  port: 2605,
  forward_agent: false,
  auth_methods: %w(publickey)
}
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

fetch(:default_env).merge!(rails_env: :staging)

namespace :deploy do
  desc 'In staging environment restart Delayed Job'
  after :finishing, 'delayed_job:restart'
end
