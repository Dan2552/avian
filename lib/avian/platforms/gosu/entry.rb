Bundler.require(:default)
require 'active_support/all'

def require_all(matcher)
  root = Bundler.root.join("..", "..")
  Dir[root.join(matcher)].each do |f|
    require f
  end
end

def mac_os_start
  window = Avian::DesktopGosuPlatform::Window.new(1125 / 3, 2436 / 3)
  window.show
rescue Interrupt
end

require "avian"

require_relative "camera"
require_relative "platform"
require_relative "sprite"
require_relative "window"
require_relative "text"

require_all('lib/**/*.rb')
require_all('app/values/**/*.rb')
require_all('app/**/concerns/*.rb')
require_all('app/**/*.rb')
require_all('config/**/*.rb')

if ENV["CONSOLE"] == "true"
  require 'irb'
  IRB.start
else
  mac_os_start
end
