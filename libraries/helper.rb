#
# Cookbook Name:: fenton_integration_test
# Library:: helper
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

# Used some of the SSH hardening described in this cookbook:
# https://github.com/dev-sec/chef-ssh-hardening

module FentonProject
  module Helper
    def allow_groups
      '*'
    end

    def ssh_service_name
      case node['platform_family']
      when %r{(rhel|fedora|suse|freebsd|gentoo)}
        'sshd'
      else
        'ssh'
      end
    end

    def ciphers
      case "#{node['platform']}-#{node['platform_version'].to_f}"
      when %r{(ubuntu-14.04|debian-8)}
        "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com," \
        "aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"
      else
        "aes256-ctr,aes192-ctr,aes128-ctr"
      end
    end

    def macs
      case "#{node['platform']}-#{node['platform_version'].to_f}"
      when %r{(ubuntu-14.04|debian-8)}
        "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com," \
        "hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com," \
        "hmac-sha2-512,hmac-sha2-256,hmac-ripemd160"
      when %r{(debian-6|rhel-.*)}
        "hmac-ripemd160,hmac-sha1"
      else
        "hmac-sha2-512,hmac-sha2-256,hmac-ripemd160"
      end
    end

    def kex_algorithms
      case "#{node['platform']}-#{node['platform_version'].to_f}"
      when %r{(ubuntu-14.04|debian-8)}
        "KexAlgorithms curve25519-sha256@libssh.org," \
        "diffie-hellman-group-exchange-sha256"
      when %r{(debian-6|rhel-.*)}
        "# KexAlgorithms"
      else
        "KexAlgorithms diffie-hellman-group-exchange-sha256"
      end
    end

    def use_privilege_separation
      case "#{node['platform']}-#{node['platform_version'].to_f}"
      when %r{(debian-6|rhel-.*|centos-6)}
        "yes" #5.3
      else
        "sandbox" #5.9+
      end
    end

    def fenton_base_url
      node['fenton_integration_test']['fenton_base_url']
    end

    def trusted_key_content
      require 'rest-client'
      require 'json'

      JSON.parse(
        RestClient.get("#{fenton_base_url}/projects/1")
      )['data']['attributes']['ca-public-key']
    end

    [Chef::Recipe,Chef::Resource].each {|klass| klass.send :include, self }
  end
end
