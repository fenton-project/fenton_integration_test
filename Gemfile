source 'https://rubygems.org'

ruby '2.2.3'

group :style, :unit, :integration do
  gem 'chef'
  gem 'rake'
  gem 'bundler-audit'
end

group :style do
  gem 'foodcritic'
  gem 'rubocop'
end

group :unit do
  gem 'berkshelf', '>= 7.0.0'
  gem 'chefspec'
  gem 'simplecov'
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-inspec', '>= 0.17.0'
end
