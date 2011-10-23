actions :install

attribute :user, :kind_of => String, :name_attribute => true
attribute :group, :kind_of => String
attribute :git_name, :kind_of => String, :required => true
attribute :git_email, :kind_of => String, :required => true
attribute :github_user, :kind_of => String, :default => nil
attribute :github_token, :kind_of => String, :default => nil
attribute :editor, :kind_of => String, :default => '/usr/bin/vim'
