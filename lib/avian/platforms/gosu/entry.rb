Bundler.require(:default)
require 'active_support/all'

def require_all(matcher)
  root = Bundler.root.join("..", "..")
  Dir[root.join(matcher)].each do |f|
    require f
  end
end

def mac_os_start
  window = Avian::Platforms::Gosu::Window.new(975, 667)
  window.show
rescue Interrupt
end

require "avian"

require_relative "camera"
require_relative "platform"
require_relative "sprite"
require_relative "window"

require_all('lib/**/*.rb')
require_all('app/**/concerns/*.rb')
require_all('app/**/*.rb')
require_all('config/**/*.rb')

if ENV["CONSOLE"] == "true"
  require 'irb'
  IRB.start
else
  mac_os_start
end
