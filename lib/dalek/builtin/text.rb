module Dalek
  module Builtin
    module Text
      def text(what) # we could probably use delegation here
        room.text(what) unless what.empty?
        what
      end
      alias :say :text
    end
  end
end
