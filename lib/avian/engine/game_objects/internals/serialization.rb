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
          instance.send(setter, attribute_value)
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
      def self.included(mod)
        mod.extend(ClassSerialization)
      end

      def as_json
        json_attributes = {}
        self.class.attributes.each do |attribute_name|
          value = send(attribute_name)
          json_attributes[attribute_name] = value
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
