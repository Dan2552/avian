module Avian
  module Platforms
    module Gosu
      class Sprite
        attr_accessor :image
        attr_accessor :x
        attr_accessor :y
        attr_accessor :z
        attr_accessor :angle
        attr_accessor :anchor_point
        attr_accessor :flipped_vertically
        attr_accessor :flipped_horizontally

        def initialize(image:, x:, y:, z:, angle:, anchor_point:, flipped_vertically: false, flipped_horizontally: false)
          @image = image
          @x = x
          @y = y
          @z = z
          @angle = angle
          @flipped_vertically = flipped_vertically
          @flipped_horizontally = flipped_horizontally
        end

        def draw_using_camera(camera)
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
            scale_x,
            scale_y
          )
        end
      end
    end
  end
end
