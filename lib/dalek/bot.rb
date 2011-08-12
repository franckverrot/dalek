require 'active_support/core_ext/module/delegation'
module Dalek
  class Bot
    def initialize(connection)
      @connection = connection
      @actions = Hash.new { |k,v| k[v] = [] }
    end


    def on(what, &block)
      @actions[what] << block
    end


    def handle_message(room, message)
      if message.type == 'TextMessage'
        # Sadly L26 instance_eval's on a room, we can't just bootstrap
        # the load method using our own DSL. #sadpanda
        if load_params = extract_params(message.body, '^load (?<url>.*)')
          room.params = load_params
          url = get_url(load_params[:url])
          begin
            code = ::Faraday.get(url).body
            instance_eval code
            room.text("Loaded code from #{url}") {}
          rescue Exception => e
            room.text("Can't load code from #{url}") {}
            room.text("Exception raised: #{e.message}") {}
            room.paste("Details: #{e.backtrace}") {}
          end
        else
          @actions.each do |action, callbacks|
            message_params = extract_params(message.body, action)
            next if message_params.nil?

            room.params = message_params
            callbacks.each { |callback| room.instance_eval(&callback) }
          end
        end
      end
    end

    def get_url(url)
      case url
      when /^gist:/
        "https://raw.github.com/gist/#{url.split(':').last}"
      else
        url
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
  end
end
