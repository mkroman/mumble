# encoding: utf-8

require 'hashie'
require 'openssl'
require 'logging'
require 'eventmachine'
require 'awesome_print'

require 'mumble/version'
require 'mumble/server'
require 'mumble/messages'
require 'mumble/connection'
require 'mumble/certificate_manager'
require 'mumble/client'

Logging.logger.root.level = :debug

Logging.color_scheme( 'bright',
  :levels => {
    :info => :green,
    :warn => :yellow,
    :error => :red,
    :fatal => [:white, :on_red]
  },
  :date => :blue,
  :logger => :bold,
  :message => :white
)

Logging.logger.root.appenders = Logging.appenders.stdout(
  'stdout',
  :layout => Logging.layouts.pattern(
    :pattern => '[%d] %-5l %c: %m\n',
    :color_scheme => 'bright'
  )
)

AwesomePrint.defaults = { multiline: false }

module Mumble
  def self.connect options = {}, &block
    Client.new(options).tap do |client|
      client.instance_eval &block
    end
  end
end
