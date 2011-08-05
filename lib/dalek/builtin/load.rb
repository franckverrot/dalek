module Dalek
	module Builtin
		module Load
			require 'faraday'
			def load(url)
				begin
          callback = http_get(url.strip)
          # room.text("Evaling this: #{callback}") {}
					instance_eval(callback)
					@room.text("Plugin loaded!") {}
				rescue Exception => e
					@room.text("Can't load this plugin: #{url}") {}
					@room.paste(e.inspect) {}
					@room.paste(e.backtrace.inspect) {}
				end
			end

      def http_get(url)
        Faraday.get(url.strip).body
      end
		end
	end
end
