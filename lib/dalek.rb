require "rubygems"
require "bundler/setup"
Bundler.setup

require 'firering'
require 'redis'

module Dalek
	autoload :Bot, 'dalek/bot'

	module Builtin
		autoload :Load, 'dalek/builtin/load'
		autoload :Say,  'dalek/builtin/say'
	end
end
