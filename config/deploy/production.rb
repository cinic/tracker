set :stage, :production
set :deploy_to, '/home/deployer/zoomator/production'
set :app_name, 'zoomator_production'
set :user, 'deployer'
set :branch, 'master'
set :foreman_env, '.env.production'
set :foreman_proc, 'Procfile.production'

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

set :ssh_options, {
  user: 'deployer',
  keys: %w(~/.ssh/id_rsa),
  port: 2605,
  forward_agent: false,
  auth_methods: %w(publickey)
}
fetch(:default_env).merge!(rails_env: :production)
