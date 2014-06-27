# encoding: utf-8

module Mumble
  class Client
    attr_accessor :options

    # Create a new client instance.
    #
    # @option options :username The client username.
    def initialize options = {}
      @options = options
    end

    # Connect to the mumble server.
    def connect
      EM.run do

      end
    end
  end
end
