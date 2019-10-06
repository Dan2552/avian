module Avian
  module DesktopGosuPlatform
    class Text
      def initialize(font_name)
        @font_name = font_name
      end

      # TODO: if attributes change, @font needs to be cleared
      attr_accessor :text,
                    :font_size,
                    :font_color,
                    :x,
                    :y

      # TODO: relative to camera
      def draw
        @font ||= Gosu::Font.new(font_size, name: @font_name)
        @font.draw_text(
          text,
          x,
          y,
          z = 999,
          scale_x = 1,
          scale_y = 1,
          font_color,
          mode = :default
        )
      end
    end
  end
end
