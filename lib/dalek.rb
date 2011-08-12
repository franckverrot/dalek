require "rubygems"
require "bundler/setup"
Bundler.setup

require 'firering'
require 'redis'
require 'nokogiri'
require 'faraday'
require 'erb'
require 'json'

module Dalek
  autoload :Bot,     'dalek/bot'
  autoload :Config,  'dalek/Config'

  module Builtin
    autoload :Text,  'dalek/builtin/text'
    autoload :Paste, 'dalek/builtin/paste'
  end

  module Plugins
    autoload :Load, 'dalek/plugins/load'
  end
end

# core-ext to externalize in its own file
class Firering::Room
  attr_accessor :params
end
