class Costume
  def self.default(*args)
    return @default if args.count == 0
    @default = args.first
  end

  def self.animation(*args)
    animation_name = args.shift
    return animations[animation_name] if args.count == 1
    animations[animation_name] = Animation.new(*args)
  end

  def self.animations
    @animations ||= {}
  end

  def initialize(value = nil)
    # TODO: animation objects need to be duped specifically for each instance
    @value = value
  end

  def inspect
    "#<#{self.class}:#{value}>"
  end

  # The current sprite value.
  #
  def value
    @value ||= self.class.default
  end

  def animate!(animation_name)
    self.class.animations.each do |iteration_animation_name, animation|
      if animation_name == iteration_animation_name
        animation.animate!
        @value = animation.value
      else
        animation.idle!
      end
    end
  end

  def idle!(animation_name)
    self.class.animations.each do |iteration_animation_name, animation|
      animation.idle!

      if animation_name == iteration_animation_name
        @value = animation.value
      end
    end
  end
end
