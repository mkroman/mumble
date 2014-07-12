# encoding: utf-8

module Mumble
  class Channel
    # @return [Integer] the channel id.
    attr_accessor :id

    # @return [String] the channel name.
    attr_accessor :name

    # @return [String] the channel description.
    attr_accessor :description

    # @return [Integer] the position index.
    attr_accessor :position

    # @return [Integer] the parent channels id.
    attr_accessor :parent_id

    # @return [Boolean] the 'temporary' flag.
    attr_accessor :temporary

    def initialize id, name
      @id = id
      @name = name
      @position = 0
      @parent_id = nil
      @temporary = false
      @description = nil
    end

    # Synchronize the channels data with that of the received channel state.
    #
    # @param [Messages::ChannelState] channel_state The channel state.
    def synchronize channel_state
      @name = channel_state.name
      @temporary = channel_state.temporary
    end

    alias_method :temporary?, :temporary
  end
end
