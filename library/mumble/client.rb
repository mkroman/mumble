# encoding: utf-8

module Mumble
  class Client
    attr_accessor :options
    attr_accessor :servers

    # Create a new client instance.
    #
    # @option options :username The client username.
    def initialize options = {}
      @log = Logging.logger[self]
      @options = options
      @servers = []
      @connection = nil
    end

    # Connect to the mumble servers.
    def connect
      EM.error_handler do |exception|
        p exception
      end

      EM.run do
        @servers.each do |server|
          connection = EM.connect server.host, server.port, Connection, server
        end
      end
    end
  end
end
