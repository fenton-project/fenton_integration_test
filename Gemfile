source 'https://rubygems.org'

ruby '2.2.3'

group :style, :unit, :integration do
  gem 'chef'
  gem 'rake'
  gem 'bundler-audit', '>= 0.7.0'
end

group :style do
  gem 'foodcritic', '>= 8.2.0'
  gem 'rubocop'
end

group :unit do
  gem 'berkshelf', '>= 7.0.2'
  gem 'chefspec'
  gem 'simplecov'
end

group :integration do
  gem 'test-kitchen', '>= 2.5.2'
  gem 'kitchen-vagrant', '>= 1.5.1'
  gem 'kitchen-inspec', '>= 1.1.0'
end
