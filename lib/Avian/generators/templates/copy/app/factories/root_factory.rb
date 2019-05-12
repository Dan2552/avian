module RootFactory
  module_function

  def build
    root = Root.new

    # By setting a tag on a GameObject you can refer from anywhere in your game
    # code. For example by calling:
    #
    # ```
    # GameObject::Base.tagged("root")
    # ```
    #
    # It is not necessary to tag your game objects unless you need this
    # functionality.
    root.tag = "root"

    root.camera = Camera.new

    root
  end
end
