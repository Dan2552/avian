require 'active_support/all'

Bundler.require(:default)

def require_all(matcher)
  root = Bundler.root.join("..", "..")
  Dir[root.join(matcher)].each do |f|
    require f
  end
end

def mac_os_start
  set width: 1125 / 3, height: 2436 / 3
  Triangle.new(
    x1: 320, y1:  50,
    x2: 540, y2: 430,
    x3: 100, y3: 430,
    color: ['red', 'green', 'blue']
  )

  show
rescue Interrupt
end

# require "avian"

# require_relative "camera"
# require_relative "platform"
# require_relative "sprite"
# require_relative "window"
# require_relative "text"

# require_all('lib/**/*.rb')
# require_all('app/values/**/*.rb')
# require_all('app/**/concerns/*.rb')
# require_all('app/**/*.rb')
# require_all('config/**/*.rb')

mac_os_start
