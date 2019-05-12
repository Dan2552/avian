# The top level node in the game graph. The game universe.
#
class Root < GameObject::Base
  has_one :camera
  has_many :examples
end
