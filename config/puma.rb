app_path = '/home/deployer/zoomator/staging/current'

environment 'staging'

rackup DefaultRackup

threads 4, 4
workers 1

daemonize false

bind "unix://#{app_path}/tmp/sockets/zoomator.sock"
state_path "#{app_path}/tmp/pids/zoomator.state"
pidfile "#{app_path}/tmp/pids/zoomator.pid"
activate_control_app "unix://#{app_path}/tmp/sockets/zoomator_ctl.sock"
stdout_redirect "#{app_path}/log/puma_access.log", "#{app_path}/log/puma_error.log"

preload_app!
