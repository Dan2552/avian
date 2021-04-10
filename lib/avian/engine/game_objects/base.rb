# Base is an empty GameObject. You should subclass this class to define your own
# game objects.
#
# The `#update` method should be overriden to define what that game object
# should do on each game loop tick. After update on the game object is complete,
# `#update` will then get called on children relationships (i.e. defined by
# `.has_one`, `.has_many`).
#
class GameObject::Base
  extend GameObject::Internals::Attributes
  extend GameObject::Internals::Behaviors
  extend GameObject::Internals::Relationships
  include GameObject::Internals::Positional
  include GameObject::Internals::Renderable
  include GameObject::Internals::Serialization

  def initialize(attrs = {})
    attrs.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

  # Tag is defined as an attribute to ensure it's serialized. See below `#tag=`
  # for actual tagging behavior.
  #
  # Also see `.find_by_tag(tag)`.
  #
  string :tag, default: nil

  # Should be called to perform an update on the GameObject and it's children.
  #
  # Children will be updated after this instance of GameObject.
  #
  # Subclasses should override the protected method `update` to define
  # behaviour for updates.
  #
  def perform_update
    raise "#perform_update called on destroyed GameObject" if @destroyed

    RenderPool.add(self) if renderable?

    # Profiler.shared_instance.start_of(self.class.to_s)

    # This specifically runs *before* the children game objects.
    update

    # Profiler.shared_instance.end_of(self.class.to_s)
    each_child(&:perform_update)
  end

  # Destroy the instance. This'll prevent the instance from behaving on any
  # more calls to `perform_update`.
  #
  # The actual destroy will take place on the next `#update` the object
  # receives.
  #
  def destroy
    will_destroy
    RenderPool.remove(self) if renderable?

    foreign_relationship_name = self.class.send(:foreign_relationship_name)

    parents.each do |parent|
      if parent.respond_to?(:"#{foreign_relationship_name}=")
        parent.send("#{foreign_relationship_name}=", nil)
      else
        parent.send("#{foreign_relationship_name.pluralize}").delete(self)
      end
    end

    @destroyed = true

    each_child(&:destroy)
    true
  end

  # A GameObject is not renderable by default.
  #
  # To be declared as renderable, you can override this method:
  #
  # ```
  # MyGameObject < GameObject::Base
  #   boolean :renderable, default: true
  #   ...
  # end
  # ```
  #
  def renderable?
    false
  end

  # When debugging, makes a GameObject recognizable compared to its id.
  #
  def inspect
    "#<#{self.class.to_s}::#{id[0..4]}>"
  end

  # When debugging, makes a GameObject recognizable compared to its id.
  #
  def to_s
    inspect
  end

  # Ensures each GameObject has a unique id.
  #
  # Particularly useful for referencing during rendering. Also helpful for
  # debugging.
  #
  def id
    @id ||= SecureRandom.uuid
  end

  def id=(set)
    @id = set
  end

  # The children to this GameObject.
  #
  # Elements should all be a GameObject as `perform_update` will be called for
  # each.
  #
  # - returns: Array of children
  #
  def each_child(&blk)
    self.class.child_relationships.each do |r|
      relation = self.send(r)

      if relation.respond_to?(:each)
        relation.each(&blk)
      elsif relation.nil?
        next
      else
        blk.call(relation)
      end
    end
  end

  def destroyed?
    !!@destroyed
  end

  def tag=(set)
    raise "Already tagged" if @tag
    @tag = set
    GameObject::Base.tagged(self)
  end

  protected

  def self.tagged(object)
    @tagged ||= {}
    @tagged[object.tag] = object
  end

  def self.find_by_tag(tag)
    @tagged ||= {}
    @tagged[tag]
  end

  # Defines actions that should be performed in the game loop.
  #
  # Subclasses should override this to provide their own functionality.
  #
  def update

  end

  # Callback for when an object is being destroyed.
  #
  # Subclasses should override this to provide their own functionality.
  #
  def will_destroy

  end

  # TODO: spec
  # For example can be used like:
  #
  # ```
  # holding = input.phase != :ended
  #
  # once(holding, for: 0.5.seconds) do
  #   puts "held"
  # end
  # ```
  #
  def once(condition, options = {}, &blk)
    key = caller.first.hash
    duration = options[:for]

    if condition
      every(duration, key, &blk)
    else
      @every_time_accrued ||= {}
      @every_time_accrued[key] = 0.0
    end
  end

  # TODO: spec
  # For example can be used like:
  #
  # ```
  # every(10.seconds) do
  #   puts Time.now
  # end
  # ```
  #
  def every(duration, key = nil, &blk)
    key = key || caller.first.hash
    @every_time_accrued ||= {}
    accrued = @every_time_accrued[key]

    if accrued
      accrued = accrued + Time.delta
    else
      accrued = 0.0
    end

    @every_time_accrued[key] = accrued

    if accrued > duration.to_f
      @every_time_accrued[key] = 0.0
      blk.call
      return
    end

    key
  end

  private

  # The parents to this GameObject.
  #
  # - returns: Array of parents
  #
  def parents
    self.class.parent_relationships.map { |r| self.send(r) }.compact.freeze
  end
end
