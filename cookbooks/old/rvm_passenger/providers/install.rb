include RvmLibrary

action :install do
  ruby_name, gemset = split_ruby_gemset(new_resource.name)
  ruby_fq = split_ruby_gemset(new_resource.name, true)
  # install passenger gem into global gemset
  rvm_gem "passenger" do
    action :install
    ruby "#{ruby_name}@global"
    version new_resource.version if new_resource.version
  end

end
