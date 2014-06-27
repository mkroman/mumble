# encoding: utf-8

module Mumble
  class Connection < EM::Connection
    # Called post-initialization.
    def post_init
      start_tls
    end
  end
end
