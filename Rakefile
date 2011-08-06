require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files   = Dir.glob("test/*_test.rb").sort
  t.verbose      = true
  t.warning      = true
end

task :default => :test

task :run do

  $:<< 'lib'
  require 'dalek'

  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

  login     = ENV['CAMPFIRE_LOGIN']
  password  = ENV['CAMPFIRE_PASSWORD']
  subdomain = ENV['CAMPFIRE_SUBDOMAIN']

  conn = Firering::Connection.new("http://#{subdomain}.campfirenow.com") do |c|
    c.login = login
    c.password = password
    c.max_retries = 10 # default to -1, which means perform connection retries on drop forever.
  end

  bot = Dalek::Bot.new(conn)

  EM.run do
    bot.run
    trap("INT") { EM.stop }
  end
end
