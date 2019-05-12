class ExampleScene
  def root
    root = RootFactory.build

    3.times do
      root.examples << ExampleFactory.build
    end

    root
  end
end
