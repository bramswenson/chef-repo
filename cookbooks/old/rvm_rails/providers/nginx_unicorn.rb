action :deploy do
  new_resource.run_context.include_recipe "nginx"
  this_resource = new_resource
  rvm_rails new_resource.name do
    action :deploy
    user this_resource.user if this_resource.user
    group this_resource.group if this_resource.group
    ruby this_resource.ruby if this_resource.ruby
    rails_env this_resource.rails_env if this_resource.rails_env
    repo this_resource.repo if this_resource.repo
    revision this_resource.revision if this_resource.revision
    repo_ssh_key this_resource.repo_ssh_key if this_resource.repo_ssh_key
    database_yml this_resource.database_yml if this_resource.database_yml
    base_path this_resource.base_path if this_resource.base_path
    environment this_resource.environment if this_resource.environment
    enable_submodules this_resource.enable_submodules if this_resource.enable_submodules
    migrate this_resource.migrate if this_resource.migrate
    migration_command this_resource.migration_command if this_resource.migration_command
  end
  unicorn_path = "/home/#{new_resource.user}/#{new_resource.rails_env}/shared/unicorn"
  rvm_unicorn unicorn_path do
    action :deploy
    ruby new_resource.ruby
    rails_env new_resource.rails_env
    user this_resource.user if this_resource.user
    group this_resource.group if this_resource.group
    listen "'#{unicorn_path}/unicorn.sock'" => ":backlog => 64"
    working_directory "/home/#{this_resource.user}/#{this_resource.rails_env}/current"
    worker_timeout "30"
    preload_app "true"
    worker_processes "2"
    before_fork "defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!"
    after_fork "defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection"
    pid "#{unicorn_path}/unicorn.pid"
    stderr_path "#{unicorn_path}/unicorn.stderr.log"
    stdout_path "#{unicorn_path}/unicorn.stdout.log"
  end
  template "/etc/nginx/sites-available/#{new_resource.name}" do
    source "nginx_rails.erb"
    cookbook "rvm_rails"
    mode "0644"
    owner this_resource.user if this_resource.user
    group this_resource.group if this_resource.group
    variables this_resource.to_hash.merge(:unicorn_path => unicorn_path)
  end
  nginx_site new_resource.name
end
