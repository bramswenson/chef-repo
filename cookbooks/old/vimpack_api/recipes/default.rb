#
# Cookbook Name:: vimpack_api
# Recipe:: default
#
# Copyright 2011, Bram Swenson
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "rvm"
include_recipe "postgresql::server"
include_recipe "postgresql::development"
include_recipe "java"
package "zip" # johnson dep


rvm_rails_nginx_unicorn "api.vimpack.org" do
  action :deploy
  user "vimpackapi"
  group "vimpackapi"
  ruby "1.9.2@vimpackapi_dev"
  rails_env :development
  repo "git@github.com:bramswenson/vimpack.org.git"
  repo_ssh_key "/tmp/vimpackapi.priv" # used once and deleted
  database_yml "/tmp/vimpackapi.yml"  # used once and deleted
  revision "master"
end
