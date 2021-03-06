module RootFactory
  def self.build
    root = Root.new

    # By setting a tag on a GameObject you can refer from anywhere in your game
    # code. For example by calling:
    #
    # ```
    # GameObject::Base.find_by_tag("root")
    # ```
    #
    # It is not necessary to tag your game objects unless you need this
    # functionality.
    root.tag = "root"

    root.camera = Camera.new
    root.screenshotter = Screenshotter.new

    root
  end
end
