actions :deploy

attribute :ruby,              :kind_of => String, :required => true
attribute :rails_env,         :kind_of => Symbol, :required => true
attribute :listen,            :kind_of => Hash, :default => {}
attribute :working_directory, :kind_of => String, :default => nil
attribute :worker_timeout, :kind_of => String, :default => 60
attribute :preload_app, :kind_of => String, :default => false
attribute :worker_processes, :kind_of => String, :default => 4
attribute :before_fork, :kind_of => String, :default => nil
attribute :after_fork, :kind_of => String, :default => nil
attribute :pid, :kind_of => String, :default => nil
attribute :stderr_path, :kind_of => String, :default => nil
attribute :stdout_path, :kind_of => String, :default => nil
attribute :notifies, :kind_of => String, :default => nil
attribute :user, :kind_of => String, :default => nil
attribute :group, :kind_of => String, :default => nil
attribute :mode, :kind_of => String, :default => nil

