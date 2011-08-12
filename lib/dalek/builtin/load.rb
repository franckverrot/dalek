module Dalek
  module Builtin
    module Load

      def self.included(klass)
        klass.class_eval do


          on "^load (?<url>.*)" do
            url = Dalek::Builtin::Load.get_url(params[:url])
            begin
            code = ::Faraday.get(params[:url]).body
            bot.instance_eval code

            rescue Exception => e
              text "Exception.raised: #{e.message}"
              paste "Details: #{e.backtrace}"
            end
          end
        end
      end



      def self.get_url(url)
        case url
          when /^gist:/
            "https://raw.github.com/gist/#{url.split(':').last}"
          else
            url
        end
      end

    end
  end
end
