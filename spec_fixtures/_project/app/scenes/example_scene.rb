class ExampleScene
  def root
    root = RootFactory.build

    root.example = ExampleFactory.build

    root
  end
end
