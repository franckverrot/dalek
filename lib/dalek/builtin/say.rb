module Dalek
	module Builtin
		module Say
			def say(what)
				@room.text(what) {}
				what
			end
		end
	end
end
