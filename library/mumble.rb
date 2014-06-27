# encoding: utf-8

require 'mumble/version'
require 'mumble/client'

module Mumble
  def self.connect options = {}, &block
    Client.new(options).tap do |client|
      client.instance_eval &block
    end
  end
end
