class Input
  def self.shared_instance
    @shared_instance ||= new
  end

  def self.get_touch(*args)
    shared_instance.get_touch(*args)
  end

  def self.touch_count
    shared_instance.touch_count
  end

  def self.get_keypresses
    shared_instance.get_keypresses
  end

  def initialize
    @touches = []
    @keypresses = {}
  end

  # - parameter index: Integer
  # - returns: Touch
  #
  def get_touch(index)
    touches[index]
  end

  # - returns: { key => KeyPress }
  #
  def get_keypresses
    keypresses.dup
  end

  # - returns: Integer
  #
  def touch_count
    touches.count
  end

  # To be called by the native platform code.
  #
  # - id: A unique id for the given touch (to distinguish between fingers)
  # - position: Location on screen
  #
  def touch_did_begin(id, position)
    # puts "did begin"
    queue << [:touch_did_begin, id, position]
  end

  # To be called by the native platform code.
  #
  # - id: A unique id for the given touch (to distinguish between fingers)
  # - position: Location on screen
  #
  def touch_did_end(id, position)
    queue << [:touch_did_end, id, position]
  end

  # To be called by the native platform code.
  #
  # - id: A unique id for the given touch (to distinguish between fingers)
  # - position: Location on screen
  #
  def touch_did_move(id, position)
    queue << [:touch_did_move, id, position]
  end

  def key_did_begin(key)
    queue << [:key_did_begin, key]
  end

  def key_did_repeat(key)
    queue << [:key_did_repeat, key]
  end

  def key_did_end(key)
    queue << [:key_did_end, key]
  end

  def update
    keypresses.delete_if { |_, keypress| keypress.phase == :ended }
    touches.delete_if { |touch| touch.phase == :ended }
    touches.each { |touch| touch.phase = :stationary }
    queue.each { |event| handle_queue_event(event) }
    self.tick = tick + 1
    self.queue, self.next_queue = next_queue, queue
    next_queue.clear
  end

  private

  attr_reader :touches
  attr_reader :keypresses

  attr_accessor :tick
  def tick
    @tick ||= 0
  end

  attr_accessor :queue
  def queue
    @queue ||= []
  end

  attr_accessor :next_queue
  def next_queue
    @next_queue ||= []
  end

  def find(id)
    touches.find { |touch| touch.id == id }
  end

  def handle_key_event(event)
    action, key = event

    phase = case action
    when :key_did_begin
      :began
    when :key_did_repeat
      :repeat
    when :key_did_end
      :ended
    end

    keypress = KeyPress.new
    keypress.key = key
    keypress.phase = phase

    if phase == :began
      eval(DEBUGGER) if !keypresses.empty?
      phase = :repeat if keypresses[key]&.phase == :began
    end

    keypresses[key] = keypress
  end

  def handle_queue_event(event)
    is_key_event = event[0] == :key_did_begin ||
      event[0] == :key_did_repeat ||
      event[0] == :key_did_end

    return handle_key_event(event) if is_key_event

    action, id, position = event

    if action == :touch_did_begin
      touch = Touch.new
      touch.id = id
      touch.original_position = position
      touch.position = position
      touch.phase = :began
      touch.last_updated = tick
      touches << touch
      return
    end

    touch = find(id)

    # If the touch last updated in this tick, we don't want to handle additional
    # events until the next.
    #
    if touch.last_updated == tick
      next_queue << event
      return
    end

    touch.last_updated = tick

    if action == :touch_did_move
      if touch.position != position
        touch.position = position
        touch.phase = :moved
      end
    elsif action == :touch_did_end
      touch.position = position
      touch.phase = :ended
    else
      touch.phase = :stationary
    end
  end
end

class Touch
  attr_accessor :id

  # :moved, :began, :ended, :stationary
  #
  attr_accessor :phase

  # Vector
  #
  attr_accessor :position

  # Vector
  #
  attr_accessor :original_position

  # Integer to track which tick the touch was last updated in.
  #
  attr_accessor :last_updated
end

class KeyPress
  attr_accessor :key

  # :began, :ended, :repeat
  attr_accessor :phase
end
