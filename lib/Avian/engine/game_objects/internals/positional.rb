module GameObject
  module Internals
    module Positional
      extend GameObject::Internals::Attributes

      vector :position
      vector :rotation, default: Vector[0,1]
      number :z_position
    end
  end
end
