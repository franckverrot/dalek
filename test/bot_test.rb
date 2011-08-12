require 'helper'
require 'test/unit'

class TestBot < Test::Unit::TestCase
  def setup
    @conn  = ::FakeConnection.new
    @room  = ::FakeRoom.new
    @bot   = ::Dalek::Bot.new(@conn)
  end

  def test_global_on
    ::Dalek::Bot.on("global_world") { text "hello" }
    @bot = ::Dalek::Bot.new(@conn)

    @bot.handle_message(@room, ::FakeMessage.new("global_world"))
    assert_equal "hello", @room.messages.last
  end

  def test_on
    @bot.on('world') { text 'hello' }
    @bot.handle_message(@room, ::FakeMessage.new('world'))
    assert_equal 'hello',   @room.messages.last
  end

  def test_on_with_parameter
    @bot.on('hello (?<who>\w+)') { text params[:who] }
    @bot.handle_message(@room, ::FakeMessage.new('hello world'))
    assert_equal 'world', @room.messages.last
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
  end
end
