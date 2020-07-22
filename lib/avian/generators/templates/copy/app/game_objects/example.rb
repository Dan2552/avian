class Example < GameObject::Base
  protected

  # Defines actions that should be performed in the game loop.
  #
  def update
    puts "hello world | #{Time.delta}"
  end
end
