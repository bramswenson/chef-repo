actions :deploy

attribute :name,              :kind_of => String, :required => true
attribute :user,              :kind_of => String, :required => true
attribute :group,             :kind_of => String, :required => true
attribute :ruby,              :kind_of => String, :required => true
attribute :rails_env,         :kind_of => [ Symbol, String ], :required => true
attribute :repo,              :kind_of => String, :required => true
attribute :revision,          :kind_of => String, :default => 'master'
attribute :repo_ssh_key,      :kind_of => String
attribute :database_yml,      :kind_of => String
# should default to /home/appname in provider
attribute :base_path,         :kind_of => String, :default => '/home'
attribute :web_stack,         :kind_of => String, :required => true
attribute :bundle_command,    :kind_of => String, :default => 'bundle install'

# copied options from deploy resource
attribute :environment,       :kind_of => Hash, :default => { }
attribute :enable_submodules, :kind_of => [ TrueClass, FalseClass ]
attribute :migrate,           :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :migration_command, :kind_of => String, :default => 'rake db:migrate'

