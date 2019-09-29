module GameObject
  module Internals
    # Defines relationships to child GameObjects, similarly to ActiveRecord
    # record relationships using `has_one`, `has_many`, `belongs_to`.
    #
    module Relationships
      def has_many(relationship_name)
        blk = Proc.new do
          subject_class = self.class.send(:class_for, relationship_name, true)
          ManyRelationship.new(self, subject_class)
        end

        define_method(relationship_name) do
          (
            instance_variable_get(:"@#{relationship_name}") ||
            instance_variable_set(:"@#{relationship_name}", instance_exec(&blk))
          )
        end

        child_relationships << relationship_name.to_sym
      end

      def has_one(relationship_name)
        _self = self

        define_method(relationship_name) do
          instance_variable_get(:"@#{relationship_name}")
        end

        define_method("#{relationship_name}=") do |new_value|
          subject_class = _self.send(:class_for, relationship_name, false)
          if new_value != nil && !new_value.is_a?(subject_class)
            raise "#{new_value} is not a #{subject_class}"
          end
          instance_variable_set(:"@#{relationship_name}", new_value)
          if new_value != nil
            new_value.instance_variable_set(:"@#{_self.send(:foreign_relationship_name)}", self)
          end
          new_value
        end

        child_relationships << relationship_name.to_sym
      end

      def belongs_to(relationship_name)
        attr_reader(relationship_name)

        parent_relationships << relationship_name.to_sym
      end

      def child_relationships
        @child_relationships ||= []
      end

      def parent_relationships
        @parent_relationships ||= []
      end

      # For belongs_to to define the correct instance variable
      #
      def foreign_relationship_name
        self.to_s
            .split("::")[-1]
            .gsub(/::/, '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
            .gsub(/([a-z\d])([A-Z])/,'\1_\2')
            .tr("-", "_")
            .downcase
      end

      def class_for(relationship_name, plural)
        relationship_name = relationship_name.to_s
        relationship_name = relationship_name.singularize if plural
        module_name = self.to_s.split("::")[0...-1].join("::")
        expected_class_name = relationship_name.titlecase.gsub(" ", "")
        "#{module_name}::#{expected_class_name}".constantize
      end
    end
  end
end
