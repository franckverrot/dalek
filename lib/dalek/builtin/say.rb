module Dalek
  module Builtin
    module Say
      def say(what)
        @room.text(what) {} unless what.empty?
        what
      end
      alias :text :say
    end
  end
end
