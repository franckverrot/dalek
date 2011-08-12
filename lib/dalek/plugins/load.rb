module Dalek
  module Plugins
    module Load

      def self.included(klass)
        klass.class_eval do


          on "^load (?<url>.*)" do
            Dalek::Plugins::Load::ClassMethods.new(params[:url], bot, self).load
          end
        end
      end

      class ClassMethods
        attr_reader :bot, :room

        def initialize(url, bot, room)
          @url, @bot, @room = url, bot, room
        end

        def load
          begin
            bot.instance_eval code
          rescue Exception => e
            room.text "Exception.raised: #{e.message}"
            room.paste "Details: #{e.backtrace}"
          end
        end

        private
        def url
          case @url
            when /^gist:/
              "https://raw.github.com/gist/#{@url.split(':').last}"
            else
              @url
          end
        end

        def code
          @code ||= ::Faraday.get(url).body
        end
      end

    end
  end
end
