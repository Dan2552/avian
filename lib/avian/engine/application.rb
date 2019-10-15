module Avian
  class Application
    class Config
      def load_defaults(version)

      end

      attr_accessor :primary_scene
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
