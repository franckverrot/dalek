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
  env = ENV.fetch('RACK_ENV','development')
  config = Dalek::Config.read(ENV.fetch('DALEK_CONFIG','config.yml'))[env]

  uri       = URI.parse(config['redis'])
  token     = config['campfire_token']
  subdomain = config['campfire_subdomain']

  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

  conn = Firering::Connection.new("http://#{subdomain}.campfirenow.com") do |c|
    c.token       = token
    c.max_retries = 10 # default to -1, which means perform connection retries on drop forever.
  end

  bot = Dalek::Bot.new(conn)

  EM.run do
    bot.run
    trap("INT") { EM.stop }
  end
end
