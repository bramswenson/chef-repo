actions :install

attribute :repo,  :kind_of => String, :required => true
attribute :ref,   :kind_of => String, :default => 'master'
attribute :user,  :kind_of => String, :required => true
attribute :group, :kind_of => String
attribute :host,  :kind_of => String, :required => true
attribute :port,  :kind_of => String, :required => true
attribute :env,   :kind_of => Hash,   :required => true
