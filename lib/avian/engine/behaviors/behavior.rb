class Behavior
  extend GameObject::Internals::Attributes

  protected

  def require_respond_to(object, method)
    raise "The #{self.class} behavior requires #{object.class} instance must respond to ##{method}." unless object.respond_to?(method)
  end
end
