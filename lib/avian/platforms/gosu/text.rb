module Avian
  module DesktopGosuPlatform
    class Text
      def initialize(font_name)
        @font_name = font_name
      end

      attr_reader :text,
                  :font_size,
                  :font_color,
                  :x,
                  :y,
                  :alignment

      def text=(set)
        @sprite = nil
        @text = set
      end

      def font_size=(set)
        @sprite = nil
        @font_size = set
      end

      def font_color=(set)
        @sprite = nil
        @font_color = set
      end

      def x=(set)
        @sprite = nil
        @x = set
      end

      def y=(set)
        @sprite = nil
        @y = set
      end

      def alignment=(set)
        @sprite = nil
        @alignment = set
      end

      def draw_using_camera(camera)
        @sprite ||= build_sprite

        @sprite.draw_using_camera(camera)
      end

      private

      attr_reader :font_name

      def build_sprite
        image = Gosu::Image.from_text(
          text,
          (font_size * 2) + 16, # magic numbers to normalize close to iOS
          font: font_name,
          align: alignment
        )

        sprite = Sprite.new(
          image: image,
          x: x,
          y: y,
          z: 999,
          angle: 0,
          flipped_vertically: false,
          flipped_horizontally: false,
          anchor_point: Vector[1, 0.0],
          multiplication_color: font_color
        )
      end
    end
  end
end
