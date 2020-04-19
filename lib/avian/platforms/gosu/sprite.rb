module Avian
  module DesktopGosuPlatform
    class Sprite
      attr_accessor :image
      attr_accessor :x
      attr_accessor :y
      attr_accessor :z
      attr_accessor :angle
      attr_accessor :anchor_point
      attr_accessor :flipped_vertically
      attr_accessor :flipped_horizontally
      attr_accessor :visible
      attr_accessor :color
      attr_accessor :color_blend_factor
      attr_accessor :x_scale
      attr_accessor :y_scale

      def initialize(attributes)
        @image = attributes[:image]
        @x = attributes[:x]
        @y = attributes[:y]
        @z = attributes[:z]
        @angle = attributes[:angle]
        @flipped_vertically = attributes[:flipped_vertically] || false
        @flipped_horizontally = attributes[:flipped_horizontally] || false
        @anchor_point = attributes[:anchor_point]
        @visible = attributes[:visible] || true
        @x_scale = 1
        @y_scale = 1
        @color_blend_factor = 0
      end

      def draw_using_camera(camera)
        return unless visible

        # Scale position in general by camera scale
        draw_x = x * camera.scale
        draw_y = y * camera.scale

        # Normalize 0,0 as center of camera
        draw_x = draw_x + camera.half_width
        draw_y = draw_y + camera.half_height

        # Adjust for camera position
        draw_x = draw_x - camera.x
        draw_y = draw_y - camera.y

        scale_x = camera.scale * 0.5
        scale_x = 0 - scale_x if flipped_vertically == true

        scale_y = camera.scale * 0.5
        scale_y = 0 - scale_y if flipped_horizontally == true

        image.draw_rot(
          draw_x,
          camera.upside_down(draw_y),
          z,
          angle,
          center_x = 1.0 - anchor_point.x,
          center_y = 1.0 - anchor_point.y,
          scale_x * x_scale,
          scale_y * y_scale
        )

        if color_blend_factor > 0
          alpha = ((0xff * color_blend_factor).to_i << 24)

          image.draw_rot(
            draw_x,
            camera.upside_down(draw_y),
            z,
            angle,
            center_x = 1.0 - anchor_point.x,
            center_y = 1.0 - anchor_point.y,
            scale_x * x_scale,
            scale_y * x_scale,
            alpha + color,
            :add
          )
        end
      end
    end
  end
end
