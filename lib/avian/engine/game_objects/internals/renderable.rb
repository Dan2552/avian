module GameObject
  module Internals
    module RenderableClass
      def renderable
        boolean :renderable, default: true
      end
    end

    module Renderable
      extend GameObject::Internals::Attributes

      boolean :relative_to_camera, default: false
      boolean :flipped_horizontally, default: false
      boolean :flipped_vertically, default: false
      boolean :renderable, default: false
      boolean :static_renderable, default: false
      boolean :visible, default: true
      vector :renderable_anchor_point, default: Vector[0.5, 0.5]
      string :sprite_name
      number :color, default: 0x000000
      number :color_blend_factor, default: 0.0
      number :x_scale, default: 1.0
      number :y_scale, default: 1.0
      attribute :shadow_overlay, default: false

      def self.included(mod)
        mod.extend(RenderableClass)
      end

      def sprite_name
        @sprite_name ||= self.class.to_s.demodulize.underscore.downcase
      end

      # The position that is used to render. This can be overridden specifically
      # to override the position something is rendered at without affecting it's
      # actual position.
      #
      def renderable_position
        position
      end

      def renderable_z_position
        z_position
      end
    end
  end
end
