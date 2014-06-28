# encoding: utf-8

module Mumble
  class Connection < EM::Connection
    # Called post-initialization.
    def post_init
      @buffer = String.new
      puts "Creating secure connection"
      start_tls :ssl_version => :TLSv1
    end

    def ssl_handshake_completed
      puts "SSL handshake completed"
    end

    def ssl_verify_peer peer_cert
      p peer_cert
    end

    def connection_completed
      puts "Connection completed"
    end

    def receive_data data
      @buffer << data

      if @buffer.bytesize >= 6
        type, length = @buffer.unpack 'nN'

        puts "Message type: #{type} - size: #{length}"
      end
      p data
    end

    def unbind
      puts "Connection lost"
    end
  end
end
