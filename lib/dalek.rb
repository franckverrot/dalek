require "rubygems"
require "bundler/setup"
Bundler.setup

require 'firering'
require 'redis'
require 'nokogiri'
require 'faraday'
require 'erb'

module Dalek
  autoload :Bot,     'dalek/bot'
  autoload :Config,  'dalek/Config'

  module Builtin
    autoload :Load,  'dalek/builtin/load'
    autoload :Text,  'dalek/builtin/text'
    autoload :Paste, 'dalek/builtin/paste'
  end
end

# core-ext to externalize in its own file
class Firering::Room
  attr_accessor :params
end
