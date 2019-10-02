module Avian
  module IOSGosuPlatform
    class Window < Gosu::Window
      attr_reader :camera

      def initialize(width, height)
        super(height, width)
        config = "Avian::Application".constantize.main.config
        "Platform".constantize.shared_instance.window = self

        primary_scene = config.primary_scene

        @scenario = primary_scene.new
        @loop ||= Loop.new(@scenario.root)
        @camera = Avian::IOSGosuPlatform::Camera.new(width, height)
      end

      def needs_cursor?
        true
      end

      def update
        handle_input

        current_time = Time.now.to_f
        @loop.perform_update(current_time * 1000)
        self.caption = "[FPS: #{::Gosu::fps.to_s}]"
      end

      def handle_input
        if touching? && !previously_touching?
          self.touch_id = SecureRandom.uuid
          Input.shared_instance.touch_did_begin(touch_id, touch)
          self.previous_touch = touch

        elsif touching? && previously_touching?
          if touch != previous_touch
            Input.shared_instance.touch_did_move(touch_id, touch)
          end
          self.previous_touch = touch

        elsif !touching? && previously_touching?
          Input.shared_instance.touch_did_end(touch_id, previous_touch)
          self.touch_id = nil
        end
      end

      def draw
        x = 0
        y = 0
        Gosu.draw_quad(x, y, 0x000000000, x+width, y, 0x000000000, x, y+height, 0x000000000, x+width, y+height, 0x000000000, 0)
        sprites.each { |sprite| sprite.draw_using_camera(camera) }
      end


      def add_sprite(texture)
        sprite = Avian::IOSGosuPlatform::Sprite.new(
          image: texture,
          x: 100,
          y: 100,
          z: 0,
          angle: 0,
          anchor_point: Vector[0.5, 0.5]
        )

        sprites << sprite

        sprite
      end

      def sprites
        @sprites ||= []
      end

      private

      attr_accessor :touch_id, :previous_touch

      def touch
        Vector[touches[0].x, camera.upside_down(touches[0].y)]
      end

      def touching?
        touches[0].present?
      end

      def previously_touching?
        touch_id != nil
      end
    end
  end
end
