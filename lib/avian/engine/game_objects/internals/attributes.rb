module GameObject
  module Internals
    module Attributes
      module Registry
        def self.register
          @register ||= {}
        end
      end

      # TODO: spec
      def attributes
        attributes = []
        ancestors.each do |ancestor|
          attributes = attributes + (Registry.register[ancestor] || [])
        end
        attributes.uniq.freeze
      end

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
      def attribute(attr_name, options = {}, &blk)
        default = options.fetch(:default, nil)
        empty = options.fetch(:empty, nil)
        type = options.fetch(:type, (default && default.class) || (empty && empty.class))
        class_name = self.name

        if type.nil? && !block_given?
          raise "When defining an attribute in a game object, it must be typed. This can be inferred from the default or empty value and if it's unable to (like in your case right now) it must be supplied as type."
        end

        if default == nil && empty != nil
          raise "The default value (#{default}) for #{attr_name} cannot be nil"
        end

        if empty && !empty.is_a?(type)
          raise "The empty value (#{empty}) for #{attr_name} does not match the type (#{type})"
        end

        attributes = Registry.register[self] ||= []
        attributes << attr_name unless attributes.include?(attr_name)

        if block_given?
          define_method(attr_name, &blk)
          define_method("#{attr_name}=") { |_| }
        else
          define_method(attr_name) do
            unless instance_variable_defined?(:"@#{attr_name}")
              if default.respond_to?(:call)
                return default.call
              else
                return default
              end
            end

            result = instance_variable_get(:"@#{attr_name}")
            return empty if result.nil?
            result
          end

          define_method("#{attr_name}=") do |new_value|
            if new_value.nil? && !empty.nil?
              raise "#{attr_name} cannot be assigned a nil value"
            end

            if type && new_value && !new_value.is_a?(type)
              if type == Fixnum && new_value.is_a?(Float) || type == Float && new_value.is_a?(Fixnum)
                # allow interchangable Fixnum/Float
              else
                raise "The :#{attr_name} attribute for #{class_name} expects the type of #{type} and therefore cannot be assigned the value: #{new_value} of type #{new_value.class}"
              end
            end

            instance_variable_set(:"@#{attr_name}", new_value)
          end
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

      def vector(attr_name, options = {})
        options = { default: Vector[0, 0] }.merge(options).merge({ type: Vector })
        attribute(attr_name, options)
      end
    end
  end
end
