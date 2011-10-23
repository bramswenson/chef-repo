action :deploy do
  this_resource = new_resource
  home_path = ::File.join(new_resource.base_path, new_resource.user)

  # create user and group
  # FIXME: need to edit path from within chef env so it can find usermod
  user new_resource.user do
    comment "#{new_resource.user} Rails App User"
    home home_path
    shell "/bin/bash"
    supports :manage_home => true
  end

  group "rvm" do
    members new_resource.user
    append true
  end

  # setup repo ssh key
  ssh_dir_path = ::File.join(home_path, '.ssh')
  ssh_key_path = ::File.join(ssh_dir_path, 'id_rsa')
  git_ssh_path = ::File.join(ssh_dir_path, 'git_ssh.sh')
  if new_resource.repo_ssh_key
    # setup key paths 
    key_file_name = ::File.split(new_resource.repo_ssh_key)[-1]

    # create .ssh dir in home dir
    directory ssh_dir_path do
      owner new_resource.user
      group new_resource.user
      mode "0700"  
      not_if %Q{ test -d #{ssh_dir_path} }
    end

    unless ::File.exists?(ssh_key_path) or ::File.exists?(new_resource.repo_ssh_key)
      raise StandardError.new("Your temp ssh key file is not in place at: #{new_resource.repo_ssh_key}")
    end
    # cp the key file into place
    bash "cp #{new_resource.repo_ssh_key} #{ssh_key_path}" do
      code %Q{ cp #{new_resource.repo_ssh_key} #{ssh_key_path} }
      not_if %Q{ test -f #{ssh_key_path} }
    end
    file ssh_key_path do
      owner new_resource.user
      mode "0600"
    end
    file "#{ssh_dir_path}/config" do
      owner new_resource.user
      content %Q{
          Host github.com
            User git
            IdentityFile #{ssh_key_path} 
      }
    end
    bash "rm #{new_resource.repo_ssh_key}" do
      code %Q{ rm #{new_resource.repo_ssh_key} }
      only_if %Q{ test -f #{new_resource.repo_ssh_key} }
    end

    # setup the GIT_SSH wrapper
    file git_ssh_path do
      content %Q{ #!/bin/bash
        host=$1
        shift
        ssh -i #{ssh_key_path} $host -x $@
      }
      owner new_resource.user
      group new_resource.user
      mode "0744"
    end

  end

  # setup the web_stack
  #rvm_passenger_apache2 "ree@potsdam" do
  #  action :install
  #end

  # setup environment attr with proper RAILS_ENV
  base_env = { 'RAILS_ENV' => new_resource.rails_env.to_s }
  base_env.merge!(new_resource.environment)

  # use chef deploy resource with existing git repo
  deploy_path = ::File.join(home_path, "#{new_resource.rails_env}")
  shared_path = ::File.join(deploy_path, 'shared')
  cached_path = ::File.join(shared_path, 'cached-copy')
  config_path = ::File.join(shared_path, 'config')
  db_yml_path = ::File.join(config_path, 'database.yml')
  directory config_path do
    action :create
    recursive true
    owner new_resource.user
    group new_resource.group
  end
  unless ::File.exists?(db_yml_path) or ::File.exists?(new_resource.database_yml)
    raise StandardError.new("Your temp database config file is not in place at: #{new_resource.database_yml}")
  end
  bash "cp #{new_resource.database_yml} #{db_yml_path}" do
    code %Q{ cp #{new_resource.database_yml} #{db_yml_path} }
    not_if %Q{ test -f #{db_yml_path} }
  end
  bash "rm #{new_resource.database_yml}" do
    code %Q{ rm #{new_resource.database_yml} }
    only_if %Q{ test -f #{new_resource.database_yml} }
  end

  rvm_gem "bundler" do
    action :install
    ruby new_resource.ruby
  end

  deploy_branch deploy_path do
    repo new_resource.repo
    revision new_resource.revision
    ssh_wrapper git_ssh_path if new_resource.repo_ssh_key
    user new_resource.user
    #enable_submodules false
    migrate true
    migration_command "rvm-shell #{new_resource.ruby} -c 'rake db:migrate'"
    environment base_env
    shallow_clone true
    action :deploy
    before_migrate do
      file "#{cached_path}/.rvmrc" do
        owner this_resource.user
        content "rvm #{this_resource.ruby}"
      end
      rvm_bundle cached_path do
        ssh_wrapper git_ssh_path if this_resource.repo_ssh_key
        ruby this_resource.ruby
        action :install
      end
    end
  end
  directory deploy_path do
    recursive true
    owner new_resource.user
    group new_resource.user   
  end

end
