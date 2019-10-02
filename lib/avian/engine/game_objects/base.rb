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
  extend GameObject::Internals::Relationships
  include GameObject::Internals::Positional
  include GameObject::Internals::Renderable
  include GameObject::Internals::Sizable

  # Should be called to perform an update on the GameObject and it's children.
  #
  # Children will be updated after this instance of GameObject.
  #
  # Subclasses should override the protected method `update` to define
  # behaviour for updates.
  #
  def perform_update
    raise "#perform_update called on destroyed GameObject" if destroyed
    delta = delta.to_f
    RenderList.shared_instance << self if renderable?
    Profiler.shared_instance.start_of(self.class.to_s)

    # This specifically runs *before* the children game objects.
    update

    Profiler.shared_instance.end_of(self.class.to_s)
    children.each(&:perform_update)
  end

  # Destroy the instance. This'll prevent the instance from behaving on any
  # more calls to `perform_update`.
  #
  # This must be called in the update loop.
  #
  def destroy
    foreign_relationship_name = self.class.send(:foreign_relationship_name)

    parents.each do |parent|
      if parent.respond_to?(:"#{foreign_relationship_name}=")
        parent.send("#{foreign_relationship_name}=", nil)
      else
        parent.send("#{foreign_relationship_name.pluralize}").delete(self)
      end
    end

    self.destroyed = true
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

  # When debugging, makes a GameObject recongizable compared to its id.
  #
  def inspect
    "#<#{self.class.to_s}::#{id[0..4]}>"
  end

  # Ensures each GameObject has a unique id.
  #
  # Particularly useful for referencing during rendering. Also helpful for
  # debugging.
  #
  def id
    @id ||= SecureRandom.uuid
  end

  # The children to this GameObject.
  #
  # Elements should all be a GameObject as `perform_update` will be called for
  # each.
  #
  # - returns: Array of children
  #
  def children
    self.class.child_relationships.map do |r|
      relation = self.send(r)
      relation.respond_to?(:to_a) ? relation.to_a : relation
    end.flatten.compact.freeze
  end

  def destroyed?
    !!destroyed
  end

  def tag=(set)
    raise "Already tagged" if @tag
    @tag = set
    GameObject::Base.tagged(self)
  end
  attr_reader :tag

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

  private

  attr_accessor :destroyed

  # The parents to this GameObject.
  #
  # - returns: Array of parents
  #
  def parents
    self.class.parent_relationships.map { |r| self.send(r) }.compact.freeze
  end
end