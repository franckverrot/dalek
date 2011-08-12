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
end
