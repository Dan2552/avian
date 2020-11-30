module Avian
  class Application
    class Config
      def load_defaults(version)
        self.background_color = 0x000000
      end

      attr_accessor :primary_scene
      attr_accessor :background_color
    end

    extend("MotionSupport::DescendantsTracker".constantize) if Object.const_defined?("MotionSupport")

    def self.main
      descendants.first
    end

    def self.config
      @config ||= Config.new
    end
  end
end
