module GameObject
  module Internals
    module Behaviors
      def behaviors
        (@behaviors ||= []).dup.freeze
      end

      def behavior(name, type:)
        define_method(name) do
          behavior_instance = instance_variable_get(:"@#{name}")
          return behavior_instance if behavior_instance

          behavior_instance = type.new(self)
          instance_variable_set(:"@#{name}", behavior_instance)
          behavior_instance
        end
      end
    end
  end
end
