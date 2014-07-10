$:.unshift File.dirname(__FILE__) + '/../library'

require 'mumble'
require 'rspec/its'

module MumbleHelpers
  def fixtures_path
    File.join File.dirname(__FILE__) + '/fixtures'
  end
end

RSpec.configure do |config|
  config.include MumbleHelpers
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
