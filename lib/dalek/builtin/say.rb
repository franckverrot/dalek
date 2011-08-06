module Dalek
	module Builtin
		module Say
			def say(what)
				@room.text(what) {} unless what.empty?
				what
			end
		end
	end
end
