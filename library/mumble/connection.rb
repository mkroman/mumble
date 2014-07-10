# encoding: utf-8

module Mumble
  class Connection < EM::Connection
    HeaderSize = 6 # The header is 6 bytes.
    HeaderFormat = 'nN' # The type is 2 bytes, and the length value is 4 bytes   def initialize client = nil

    # Create a new server connection.
    #
    # @param [Server] server The server reference.
    def initialize server = nil
      @server = server
      @server.connection = self

      super
    end

    # Called post-initialization.
    def post_init
      @log = Logging.logger[self]
      @buffer = String.new
      @message_handlers = []

      @log.debug "Creating secure connection"

      tls_options = {
        ssl_version: :TLSv1,
        private_key_file: @server.cert_manager.private_key_path,
        cert_chain_file: @server.cert_manager.public_certificate_path
      }

      start_tls tls_options
    end

    def ssl_handshake_completed
      @log.debug "SSL handshake completed"

      @server.connection_completed
    end

    def ssl_verify_peer peer_cert
      p peer_cert
    end

    # Called when data have been received.
    def receive_data data
      @buffer << data

      while @buffer.bytesize >= HeaderSize
        # Read the header.
        type, length = @buffer.unpack HeaderFormat
        message_size = HeaderSize + length

        # Read the body.
        if @buffer.bytesize >= message_size
          if klass = Messages::MessageTypes[type]
            # Parse the message.
            message = klass.new
            message.parse_from_string @buffer.slice HeaderSize, length

            @server.receive_message message
          end

          @buffer.slice! 0, message_size
        end
      end
    end

    # Send a message to the server.
    #
    # @param [Protobuf::Message] message_type The message class.
    # @param [Hash] attributes The message attributes.
    def send_message message_type, attributes = {}
      message = message_type.new

      attributes.each do |name, value|
        message.__send__ :"#{name}=", value
      end

      @log.debug "Sending message #{message_type}"
      @log.debug message.to_hash.ai

      body = message.serialize_to_string
      header = [Messages::MessageTypes.key(message_type), body.bytesize].pack HeaderFormat

      send_data header + body
    end

    def unbind
      @log.fatal "Connection lost"
    end
  end
  
end
