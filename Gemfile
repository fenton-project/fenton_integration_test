source 'https://rubygems.org'

ruby '2.2.3'

group :style, :unit, :integration do
  gem 'chef'
  gem 'rake'
  gem 'bundler-audit'
end

group :style do
  gem 'foodcritic', '>= 8.1.0'
  gem 'rubocop'
end

group :unit do
  gem 'berkshelf'
  gem 'chefspec'
  gem 'simplecov'
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-inspec'
end
