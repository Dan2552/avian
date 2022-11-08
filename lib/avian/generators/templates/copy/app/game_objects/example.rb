class Example < GameObject::Base
  renderable
  string :sprite_name, default: "birds"
  number :speed, default: -> { [500, 400, 300].sample }

  protected

  # Defines actions that should be performed in the game loop.
  #
  def update
    puts "hello world | #{Time.delta}"

    if position.x > 300
      self.speed = -500
    elsif position.x < -300
      self.speed = 500
    end

    self.position = Vector.new(position.x + speed * Time.delta, 0)
  end
end
