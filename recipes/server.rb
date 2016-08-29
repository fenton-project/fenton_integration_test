#
# Cookbook Name:: fenton_integration_test
# Recipe:: server
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

node.override['fenton_integration_test']['ruby_version'] = version = File.read('/fenton_server/Gemfile').scan(/ruby '([0-9]*\.[0-9]*\.[0-9]*)'/).flatten.first.strip
node.override['fenton_integration_test']['folder'] = '/fenton_server'

include_recipe "#{cookbook_name}::install_ruby"

execute 'run server' do
  cwd '/fenton_server'
  user 'root'
  group 'root'
  environment({"HOME" => "/root", "USER" => "root"})
  command <<-EOH
    bash -l -c "kill `ps auxww | grep [f]enton_server | awk '{print $2}'`"
    bash -l -c 'rvm use #{version}; bundle exec ./bin/rails db:environment:set RAILS_ENV=development'
    bash -l -c 'rvm use #{version}; bundle exec rake db:drop && bundle exec rake db:setup'
    bash -l -c 'rvm use #{version}; bundle exec puma --redirect-stdout log/server.log --redirect-stderr log/server.log --redirect-append --daemon --bind tcp://0.0.0.0 --port 9292'
  EOH
  live_stream true
end
