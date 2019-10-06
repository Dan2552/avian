module Avian
  module DesktopGosuPlatform
    class Camera
      attr_accessor :x, :y, :width, :height, :scale

      def initialize(width, height)
        @width = width
        @height = height
        @scale = 1
      end

      def x
        @x ||= 0
      end

      def y
        @y ||= 0
      end

      def half_width
        @half_width ||= width / 2
      end

      def half_height
        @half_height ||= height / 2
      end

      # e.g. (10) needs to be (screen - 10)
      #
      def upside_down(y)
        height - y
      end
    end
  end
end
