#
# Cookbook Name:: fenton_integration_test
# Recipe:: install_ruby
#
# Copyright 2016 Nick Willever
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

version = node['fenton_integration_test']['ruby_version'] 

apt_update 'run_update' do
  action :update
  only_if { node['platform_family'] == 'debian' }
  not_if 'dpkg --status curl'
end

package 'curl'

execute 'install rvm' do
  user 'root'
  command <<-EOH

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    bash -l -c 'rvm rvmrc warning ignore allGemfiles'
  EOH
  live_stream true
  not_if "bash -l -c 'rvm list | grep #{version}'"
end

execute "install ruby #{version}" do
  user 'root'
  command <<-EOH

    bash -l -c 'rvm install ruby-#{version}'
  EOH
  live_stream true
  not_if "bash -l -c 'rvm list | grep #{version}'"
end

execute 'run bundle install' do
  cwd node['fenton_integration_test']['folder']
  user 'root'
  command "bash -l -c 'rvm use #{version}; gem install bundler --no-ri --no-rdoc && bundle install'"
  live_stream true
end
