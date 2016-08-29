#
# Cookbook Name:: fenton_integration_test
# Recipe:: machine
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

build_package = case node['platform_family']
when 'debian'
  'g++'
when 'rhel', 'fedora'
  'gcc-c++'
end

execute 'apt-get update' do
  command 'apt-get update'
  action :nothing
  only_if { node['platform_family'] == 'debian' }
end.run_action(:run)

package build_package do
  action :nothing
  not_if { node['platform_family'] == 'fedora'}
end.run_action(:install)

execute 'install gcc-c++ for fedora' do
  command 'dnf install -y gcc-c++'
  action :nothing
  only_if { node['platform_family'] == 'fedora'}
end.run_action(:run)

chef_gem 'rest-client'

package 'openssh-server' do
  not_if { node['platform_family'] == 'fedora'}
end

execute 'install openssh-server with dnf for fedora' do
  command 'dnf install -y openssh-server'
  only_if { node['platform_family'] == 'fedora'}
end

directory '/etc/ssh' do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

file 'create trusted key' do
  path '/etc/ssh/trusted_user_ca_key'
  content(lazy { trusted_key_content })
end

directory '/etc/ssh/authorized_keys'

execute 'mv vagrant ssh key to new location' do
  command <<-EOH
    mv /home/vagrant/.ssh/authorized_keys /etc/ssh/authorized_keys/vagrant
  EOH
  action :run
  only_if { File.exists? ("/home/vagrant/.ssh/authorized_keys") }
end

template 'sshd_config' do
  path '/etc/ssh/sshd_config'
  source 'sshd_config.erb'
  owner 'root'
  group 'root'
  mode 0600
  variables(
    listen_address: '0.0.0.0',
    ciphers: ciphers,
    macs: macs,
    kex_algorithms: kex_algorithms,
    use_privilege_separation: use_privilege_separation,
    allow_groups: allow_groups
  )
  notifies :restart, 'service[sshd]'
end

service 'sshd' do
  service_name ssh_service_name
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
