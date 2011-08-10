require 'webmock'
include WebMock::API

class Stub
  class << self
    attr_accessor :mocks_path
    @mocks_path = File.dirname(__FILE__)
  end

  def self.with_file(method, url, file, options = {})
    stub_request(method, url).
      to_return(:status => 200, :body => File.read(file))
  end
end

