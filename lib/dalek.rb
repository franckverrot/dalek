require "rubygems"
require "bundler/setup"
Bundler.setup

require 'firering'
require 'redis'
require 'nokogiri'

module Dalek
	autoload :Bot, 'dalek/bot'

	module Builtin
		autoload :Load,  'dalek/builtin/load'
		autoload :Say,   'dalek/builtin/say'
		autoload :Paste, 'dalek/builtin/paste'
	end
end
