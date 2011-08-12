require 'helper'
require 'test/unit'

class TestLoad < Test::Unit::TestCase

  def setup
    @conn = ::FakeConnection.new
    @room = ::FakeRoom.new
    @bot = ::Dalek::Bot.new(@conn)
  end

  def test_has_load_method
    assert_kind_of Array, @bot.actions["^load (?<url>.*)"]
  end

  def test_load_remote_file
    url   = 'http://www.example.com/hello_world.rb'
    file  = 'test/mocks/hello_world.rb'
    Stub.with_file(:get, url, file)
    @bot.handle_message(@room, ::FakeMessage.new("load #{url}"))
    @bot.handle_message(@room, ::FakeMessage.new("hello"))
    assert_equal 'world', @room.messages.last
  end

  def test_remote_with_payload
    url   = 'http://www.example.com/with_params.rb'
    file  = 'test/mocks/with_params.rb'
    Stub.with_file(:get, url, file)
    @bot.handle_message(@room, ::FakeMessage.new("load #{url}"))

    @bot.handle_message(@room, ::FakeMessage.new("ping cesario"))
    assert_equal 'hello cesario', @room.messages.last

    @bot.handle_message(@room, ::FakeMessage.new("ping dmathieu"))
    assert_equal 'hello dmathieu', @room.messages.last
  end
end
