require 'rake'
require 'kitchen'
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'bundler/audit/cli'

desc "Check Style"
task style: ['style:chef', 'style:ruby']

namespace :style do
  desc "Check Ruby Style Only"
  RuboCop::RakeTask.new :ruby

  desc "Check Chef Style with FoodCritic"
  FoodCritic::Rake::LintTask.new :chef do |task|
    task.options = { fail_tags: %w(any) }
  end
end

desc "Run all tests"
task test: %w(test:unit test:integration)

namespace :test do
  desc "Run chefspec unit tests"
  RSpec::Core::RakeTask.new :unit

  desc "Run test-kitchen integration tests"
  task :integration do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

namespace :bundler do
  desc 'Updates the ruby-advisory-db and runs audit'
  task :audit do
    %w(update check).each do |command|
      Bundler::Audit::CLI.start [command]
    end
  end
end

task default: %w(style test)
