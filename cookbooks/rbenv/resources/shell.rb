actions :run

attribute :command, :kind_of => String, :name_attribute => true
attribute :code, :kind_of => String
attribute :version, :kind_of => String
attribute :cwd, :kind_of => String
attribute :user, :kind_of => String, :required => true
attribute :group, :kind_of => String
