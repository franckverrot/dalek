module Dalek
	module Builtin
		module Paste
			def paste(what)
				@room.paste(what) {} unless what.empty?
				what
			end
		end
	end
end
