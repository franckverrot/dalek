require 'helper'
require 'test/unit'

class TestBot < Test::Unit::TestCase
  def setup
    @conn  = ::FakeConnection.new
    @room  = ::FakeRoom.new
    @bot   = ::Dalek::Bot.new(@conn)
  end

  def test_on
    proxy = Dalek::Bot::RoomProxy.new(@room)
    proxy.on('world') { :hello }
    assert_equal :hello, proxy.world
    assert_equal :hello, REDIS.get('world').call
  end

  def test_load_remote_file
    url   = 'http://www.example.com/hello_world.rb'
    file  = 'test/mocks/hello_world.rb'
    proxy = Dalek::Bot::RoomProxy.new(@room)
    Stub.with_file(:get, url, file)
    proxy.load(url)
    assert_equal 'world', proxy.hello
  end

  def test_remote_with_payload
    url   = 'http://www.example.com/with_params.rb'
    file  = 'test/mocks/with_params.rb'
    proxy = Dalek::Bot::RoomProxy.new(@room, 'foo bar')
    Stub.with_file(:get, url, file)
    proxy.load(url)
    assert_equal 'foo bar', proxy.ping('foo bar') #bleh this sucks... the payload is L32
  end
end
