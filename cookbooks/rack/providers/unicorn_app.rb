action :install do
  name  = new_resource.name
  repo  = new_resource.repo
  ref   = new_resource.ref
  user  = new_resource.user
  group = new_resource.group || user
  host  = new_resource.host
  port  = new_resource.port
  env   = new_resource.env

  apps_dir    = node[:rack][:apps_dir]
  app_dir     = ::File.join(apps_dir,   name)
  shared_dir  = ::File.join(app_dir, 'shared')
  config_dir  = ::File.join(shared_dir, 'config')
  log_dir     = ::File.join(shared_dir, 'log')
  tmp_dir     = ::File.join(shared_dir, 'tmp')
  current_dir = ::File.join(app_dir, 'current')
  bundle_dir  = ::File.join(shared_dir, 'bundle')

  unicorn_config = ::File.join(config_dir, 'unicorn.rb')
  pid_path       = ::File.join(tmp_dir,    'unicorn.pid')
  stderr_path    = ::File.join(log_dir,    'unicorn.stderr.log')
  stdout_path    = ::File.join(log_dir,    'unicorn.stdout.log')

  # create app dirs
  directory apps_dir do
    action :create
    recursive true
    mode 0755
  end
  directory app_dir do
    action :create
    mode 0755
    owner user
    group group
  end
  directory app_dir do
    action :create
    mode 0755
    owner user
    group group
  end
  directory shared_dir do
    action :create
    mode 0755
    owner user
    group group
  end
  directory config_dir do
    action :create
    mode 0755
    owner user
    group group
  end
  directory log_dir do
    action :create
    mode 0755
    owner user
    group group
  end
  directory tmp_dir do
    action :create
    mode 0755
    owner user
    group group
  end
  directory bundle_dir do
    action :create
    mode 0755
    owner user
    group group
  end

  # setup unicorn config
  template unicorn_config do
    cookbook 'rack'
    source 'unicorn.rb.erb'
    owner user
    group group
    variables(
      :path        => current_dir,
      :host        => host,
      :port        => port,
      :env         => env['RAILS_ENV'],
      :user        => user,
      :group       => group,
      :pid_path    => pid_path,
      :stderr_path => stderr_path,
      :stdout_path => stdout_path
    )
  end

  # deploy resource
  deploy_revision app_dir do
    repo repo
    revision ref
    user user
    group group
    enable_submodules true
    migrate false
    environment env
    #action :deploy
    action :force_deploy
    #restart_command "touch tmp/restart.txt"

    before_migrate do
      rbenv_shell "#{name} bundle install" do
        action :run
        user user
        group group
        version '1.9.2-p290'
        cwd release_path
        code <<-CODE
          echo `ruby -v` && \
          gem install bundler && \
          rbenv rehash && \
          bundle install && \
          rbenv rehash
        CODE
          #bundle install --path #{bundle_dir} --without development test --deployment && \
      end
    end
  end
  # setup monit for app
end

