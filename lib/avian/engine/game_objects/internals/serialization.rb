module GameObject
  module Internals
    module ClassSerialization
      def from_json(json_string)
        from_as_json(JSON.parse(json_string))
      end

      def from_as_json(as_json)
        instance = as_json["type"].constantize.new

        instance.id = as_json["id"]

        as_json["attributes"].each do |attribute_name, attribute_value|
          next if attribute_name == "pathfinder"
          next if attribute_name == "direction"
          setter = :"#{attribute_name}="

          is_value_object =
            attribute_value.is_a?(Hash) &&
            attribute_value.key?("type") &&
            attribute_value.key?("value")

          if is_value_object
            value_class = attribute_value["type"].constantize
            value = attribute_value["value"]

            value_instance = value_class.from_value(value)

            begin
              instance.send(setter, value_instance)
            rescue => e
              puts e
              eval(DEBUGGER)
            end
          else
            instance.send(setter, attribute_value)
          end
        end

        as_json["children"].each do |child_as_json|
          relationship_name = child_as_json["type"].underscore
          child = GameObject::Base.from_as_json(child_as_json)

          if instance.respond_to?(relationship_name.pluralize)
            many_relationship = instance.send(relationship_name.pluralize)
            many_relationship << child
          else
            setter = :"#{relationship_name}="
            instance.send(setter, child)
          end
        end

        instance
      end
    end

    module Serialization
      JSON_TYPES = [
        Numeric,
        Hash,
        String,
        NilClass,
        Boolean
      ].freeze

      def self.included(mod)
        mod.extend(ClassSerialization)
      end

      def as_json
        json_attributes = {}
        self.class.attributes.each do |attribute_name|
          value = send(attribute_name)
          json_attributes[attribute_name] =
          if JSON_TYPES.any? { |json_type| value.is_a?(json_type) }
            json_attributes[attribute_name] = value
          else
            {
              type: value.class.to_s,
              value: value.value
            }
          end
        end

        children = []
        each_child do |child|
          children << child.as_json
        end

        {
          id: id,
          type: self.class.name,
          attributes: json_attributes,
          children: children
        }
      end

      def to_json
        as_json.to_json
      end
    end
  end
end
