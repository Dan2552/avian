module GameObject
  module Internals
    module PreviousFrameInstance
      # Returns a hash of values captured from the previous frame. For example
      # this could be used to get the rendered position of a game object even if
      # the position attribute has been updated since.
      #
      # Positional attributes (see GameObject::Internals::Positional) are
      # tracked by default. To track extra attributes you can use the
      # `.capture_previous` class method in your game object definition.
      #
      # Note: the returned hash will always be empty on the first frame of the
      # game.
      #
      def previous_frame
        @previous_frame ||= {}.freeze
      end

      protected

      # Called by GameObject::Base#update
      #
      def capture_previous
        @previous_frame = {}
        self.class.capture_previous.each do |attr_name|
          @previous_frame[attr_name] = send("#{attr_name}")
        end
      end
    end
  end
end
