require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.formatter = 'documentation'
  config.order = 'random'
  config.color = true
end

Chef::Log.init('/dev/null')

$VERBOSE = nil

module Kernel
  def deprecated(*)
  end
end

at_exit { ChefSpec::Coverage.report! }
