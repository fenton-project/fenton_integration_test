# Inspec examples can be found at
# https://github.com/chef/inspec/blob/master/docs/resources.rst

ssh_command = <<-EOH
bash -l -c "cd /fenton_shell && rvm use 2.2.3 && \
bundle exec ./bin/fenton machine ssh vagrant@192.168.200.20 -c hostname"
EOH

describe command(ssh_command) do
  its('stdout') { should match %r{machine-} }
end
