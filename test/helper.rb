$:.unshift File.expand_path("../lib", __FILE__)
$:.unshift File.expand_path("../mocks", __FILE__)

require 'dalek'
require 'mocks/stub'
WebMock.disable_net_connect!(:allow_localhost => true)

# Implement a minimal interface for Redis
REDIS = Class.new(Hash) do
  def set(key, value)
    self[key] = value
  end

  def get(key)
    self[key]
  end
end.new

class FakeConnection
end

class FakeRoom
  attr_accessor :messages
  attr_accessor :params

  def text(what)
    messages << what
  end

  alias :paste :text

  def initialize
    @messages = []
    @params = {}
  end
end


class FakeMessage
  attr_accessor :body
  def type; 'TextMessage' end
  def initialize(body)
    @body = body
  end
end
