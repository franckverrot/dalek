$:.unshift File.expand_path("../lib", __FILE__)
require 'dalek'

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
  def text(*args); end
  alias :paste :text
end
