module TestGame
  class Application < Avian::Application
    # Initialize configuration defaults for originally generated Avian version.
    config.load_defaults 0.1
    config.primary_scene = ExampleScene
  end
end
