require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/attribute_accessors'

module Dalek
  class Bot
    cattr_accessor :global_actions
    @@global_actions = Hash.new { |k,v| k[v] = [] }

    attr_reader :actions

    def initialize(connection)
      @connection = connection
      @actions = Hash.new { |k,v| k[v] = [] }
      @actions.merge!(self.class.global_actions)
    end

    def self.on(what, &block)
      global_actions[what] << block
    end

    def on(what, &block)
      @actions[what] << block
    end

    def handle_message(room, message)
      if message.type == 'TextMessage'
        actions.keys.each do |action|
          callbacks = @actions[action]
          message_params = extract_params(message.body, action)
          next if message_params.nil?

          # TODO : use a request object
          room.params = message_params
          room.bot = self
          callbacks.each { |callback| room.instance_eval(&callback) }
        end
      end
    end

    def extract_params(message,action)
      Regexp.new(rework_action(action)).match(message)
    end

    # Will be used to simplify regexps
    # 'hello (?<world>\w+)' will become 'hello :world'
    def rework_action(action)
      action
    end
    private :rework_action

    def run
      @connection.authenticate do |user|
        @connection.rooms do |rooms|
          rooms.each do |room|
            room.stream do |message|
              handle_message(room, message)
            end
          end
        end
      end
    end
    include Builtin::Text
    include Builtin::Paste
    include Builtin::Load
  end
end
