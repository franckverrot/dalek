require 'active_support/core_ext/module/delegation'
module Dalek
  class Bot
    class RoomProxy
      include Builtin::Text
      include Builtin::Paste
      include Builtin::Load

      attr_accessor :room

      def initialize(room, payload = '')
        @room, @payload = room, payload
      end
      delegate :text, :to => :room
      delegate :paste, :to => :room

      def on(what, &block)
        add_action(what, block)
        self.class.send(:define_method, what, &block)
      end
      alias :get :on

      def add_action(what, block)
        actions = REDIS.get('actions') || []
        actions << what
        REDIS.set('actions', actions)
        REDIS.set(what, block)
      end
      private :add_action
    end

    def initialize(connection)
      @connection = connection
    end


    def run
      @connection.authenticate do |user|
        @connection.rooms do |rooms|
          rooms.each do |room|
            room.stream do |message|
              if message.type == 'TextMessage'
                message.body =~ /(\w+)(.*)?/
                action, payload = $1, $2.strip
                room_proxy = RoomProxy.new(room, payload)
                if room_proxy.respond_to?(action)
                  if room_proxy.method(action).arity == 0
                    room_proxy.send action
                  else
                    room_proxy.send action, payload
                  end
                else
                  if action == 'help'
                    room_proxy.text "Actions: #{REDIS.get('actions').inspect}" do end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
