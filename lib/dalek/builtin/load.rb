module Dalek
  module Builtin
    module Load
      def load(url)
        EM.run do
          http = EventMachine::HttpRequest.new(url.strip).get
          http.errback { EM.stop }
          http.callback do
            response = http.response
            begin
              instance_eval(response)
              @room.text("Plugin loaded!")
            rescue Exception => e
              @room.text("Can't load this plugin: #{url}")
              @room.paste(e.inspect)
              @room.paste(e.backtrace.inspect)
            end
            EM.stop
          end
        end
      end
    end
  end
end
