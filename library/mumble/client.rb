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
        @connection = EM.connect "uplink.io", 64738, Connection
        p @connection
      end
    end
  end
end
