source 'https://rubygems.org'

ruby '2.2.3'

group :style, :unit, :integration do
  gem 'chef', '>= 12.17.44'
  gem 'rake'
  gem 'bundler-audit'
end

group :style do
  gem 'foodcritic', '>= 8.2.0'
  gem 'rubocop'
end

group :unit do
  gem 'berkshelf', '>= 5.3.0'
  gem 'chefspec', '>= 5.4.0'
  gem 'simplecov'
end

group :integration do
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-inspec', '>= 0.17.0'
end
