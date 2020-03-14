module GameObject
  module Internals
    module PreviousFrameClass
      # Call this method to track attributes between frame updates.
      #
      # The `#previous_frame` hash will include any keys that have been passed
      # into this method as an argument.
      #
      def capture_previous(*names)
        if self == "GameObject::Base".constantize
          @capture_previous ||= []
        else
          @capture_previous = "GameObject::Base".constantize.capture_previous
        end

        return @capture_previous if names.empty?
        names.each { |name| @capture_previous << name.to_sym }
      end
    end
  end
end
