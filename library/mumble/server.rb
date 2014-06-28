# encoding: utf-8

module Mumble
  class Server
    # Create a new server connection handler.
    #
    # @param [String] host            The remote hosts name or IP-address.
    # @param [Fixnum, optional] port  The remote hosts port.
    # @param [Hash, optional] options The list of extra options.
    def initialize host, port = 64738, options = {}
      @host = host
      @port = port
      @options = options
    end

    # Called when the server handler receives a message.
    #
    # @param message The received message.
    def receive_message message

    end
  end
end
