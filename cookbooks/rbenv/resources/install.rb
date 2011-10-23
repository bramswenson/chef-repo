actions :install

attribute :name,  :kind_of => String,   :name_attribute => true
attribute :user,  :kind_of => String,   :required => true
attribute :group, :kind_of => String
attribute :version, :kind_of => String, :required => true
