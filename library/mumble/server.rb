# encoding: utf-8

module Mumble
  class Server
    # @return [String] The server host.
    attr_accessor :host

    # @return [Fixnum] The server port.
    attr_accessor :port

    # @return [Connection] The server connection.
    attr_accessor :connection

    # @return [Hash] the server options.
    attr_accessor :options

    attr_accessor :cert_manager

    # Create a new server connection handler.
    #
    # @param [String] host            The remote hosts name or IP-address.
    # @param [Fixnum, optional] port  The remote hosts port.
    # @param [Hash, optional] options The list of extra options.
    def initialize host, port = 64738, options = {}
      @log = Logging.logger[self]
      @host = host
      @port = port
      @options = options
      @cert_manager = CertificateManager.new

      unless @options.key? :username
        raise ServerError, 'no :username is provided'
      end
    end

    # Called when the sever connection is established.
    def connection_completed
      @log.info "Connection established with #{@host}:#{@port}."

      send_version

      username = @options[:username]
      password = @options[:password] || 'password'
      authenticate username, password
    end

    # Called when the server handler receives a message.
    #
    # @param [Protobuf::Message] message The received message.
    def receive_message message
      @log.debug "<< #{message.to_hash.ai}"
    end

    # Exchange the version information with the server.
    def send_version
      attributes = {
        os_version: "Linux",
        version: 66055,
        release: "1.2.7",
        os: "X11"
      }

      @connection.send_message Messages::Version, attributes
    end

    # Authenticate with the server.
    #
    # @param [String] username The username.
    # @param [String] password The password.
    def authenticate username, password
      attributes = {
        username: username,
        password: password,
        opus: true
      }

      @connection.send_message Messages::Authenticate, attributes
    end
  end
end
