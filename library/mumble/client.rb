# encoding: utf-8

module Mumble
  class Client
    attr_accessor :options

    # Create a new client instance.
    #
    # @option options :username The client username.
    def initialize options = {}
      @log = Logging.logger[self]
      @options = options
      @connection = nil
    end

    # Connect to the mumble server.
    def connect
      EM.run do
        @connection = EM.connect "uplink.io", 64738, Connection, self
      end
    end

    def receive_message message
      case message
      when Messages::Version
      end
      @log.debug "Received message #{message.to_hash.ai}"
    end

    def connection_completed
      send_version
      send_authentication
    end

    def send_version
      @log.debug "Sending version to the server"

      @connection.send_message Messages::Version, {
        os_version: "hest",
           version: 66055,
           release: "1.2.7",
                os: "X11"
      }
    end

    def send_authentication
      @log.debug "Sending authentication to the server"

      @connection.send_message Messages::Authenticate, {
        username: "meta",
        password: "1234",
        opus: true
      }
    end
  end
end
