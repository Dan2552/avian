module GameObject
  module Internals
    module Attributes
      # - parameter attr_name: The same of the attribute. This will be used to
      #   define the getter and setter method names.
      #
      # - parameter options[:default]: The starting value of the attribute. If
      #   this is set as a proc, the value will be evaluated lazily.
      #
      # - parameter options[:empty]: If the attribute is not nil-able, this
      #   should be set to provide an alternative "empty" state. If this is set,
      #   and setter is sent a nil, an exception will be raised.
      #
      # - parameter options[:type]: The type of the attribute. If this is set,
      #   the attribute will be type checked on assignment.
      #
      def attribute(attr_name, options = {})
        default = options.fetch(:default, nil)
        empty = options.fetch(:empty, nil)
        type = options.fetch(:type, (default && default.class) || (empty && empty.class))

        if default == nil && empty != nil
          raise "The default value (#{default}) for #{attr_name} cannot be nil"
        end

        if empty && !empty.is_a?(type)
          raise "The empty value (#{empty}) for #{attr_name} does not match the type (#{type})"
        end

        define_method(attr_name) do
          unless instance_variable_defined?(:"@#{attr_name}")
            if default.respond_to?(:call)
              return default.call
            else
              return default
            end
          end

          instance_variable_get(:"@#{attr_name}") || empty
        end

        define_method("#{attr_name}=") do |new_value|
          if new_value.nil? && !empty.nil?
            raise "#{attr_name} cannot be assigned a nil value"
          end

          if type && new_value && !new_value.is_a?(type)
            binding.pry
            raise "#{attr_name} (#{type}) cannot be assigned #{new_value} (#{new_value.class})"
          end

          instance_variable_set(:"@#{attr_name}", new_value)
        end
      end

      def number(attr_name, options = {})
        options = { default: 0 }.merge(options).merge(type: Numeric)
        attribute(attr_name, options)
      end

      def string(attr_name, options = {})
        options = { default: "" }.merge(options).merge(type: String)
        attribute(attr_name, options)
      end

      def boolean(attr_name, options = {})
        options = { default: false }.merge(options).merge(type: Boolean)
        attribute(attr_name, options)

        define_method("#{attr_name}?") do
          value = send(:"#{attr_name}")
          value != false && value != nil
        end
      end

      def behavior(attr_name, options = {})
        options = { type: "Behavior".constantize }.merge(options)
        attribute(attr_name, options)
      end

      def vector(attr_name, options = {})
        options = { default: Vector[0, 0] }.merge(options).merge({ type: Vector })
        attribute(attr_name, options)
      end
    end
  end
end
