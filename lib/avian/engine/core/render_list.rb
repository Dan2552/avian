class RenderList
  def self.shared_instance
    @shared_instance ||= new
  end

  # Clears the render list.
  #
  # Should be called at the start of the game loop.
  #
  def clear!
    # Profiler.shared_instance.start_of("RenderList#clear")
    list.clear
    # Profiler.shared_instance.end_of("RenderList#clear")
  end

  # Add an element to the render list.
  #
  # Should be called within the game loop.
  #
  def <<(game_object)
    raise "#{game_object} is not renderable" unless game_object.renderable?
    list << game_object
  end

  # Iterates over the list of elements to be rendered.
  #
  # Should be called by the renderer.
  #
  def each(&blk)
    list.each(&blk)
  end

  private

  def list
    @list ||= []
  end
end
