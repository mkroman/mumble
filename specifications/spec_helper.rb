$:.unshift File.dirname(__FILE__) + '/../library'

require 'mumble'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
