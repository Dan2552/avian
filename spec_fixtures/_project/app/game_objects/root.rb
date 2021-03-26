# The top level node in the game graph. The game universe.
#
class Root < GameObject::Base
  # Define relationships for each node in order to determine the structure for
  # your game graph.
  #
  # - `has_one` or `has_many` defines child relationships.
  # - `belongs_to` defines parent relationships.
  #
  has_one :example

  # The camera should generally be defined as the last relationship here so that
  # it's `#update` is called last. For example, if the camera were following the
  # the player object's `#position`, you'd want to follow the position after the
  # current frame's update on the player.
  #
  has_one :camera
  has_one :screenshotter
end
