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
  def text(what); what; end
  alias :paste :text
end
