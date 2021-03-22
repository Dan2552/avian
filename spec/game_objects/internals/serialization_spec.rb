class MyValue
  include Value
end

class TestSerializationParent < GameObject::Base
  has_one :test_serialization_child

  number :test_number, default: 25
  attribute :my_value, default: MyValue.new(25)
end

class TestSerializationChild < GameObject::Base
  belongs_to :test_serialization_parent
  has_many :test_serialization_grand_children

  string :test_string, default: "Banana"
end

class TestSerializationGrandChild < GameObject::Base
  belongs_to :test_serialization_child

  boolean :test_boolean, default: true
end

describe GameObject::Internals::ClassSerialization do
  describe ".from_as_json" do
    let(:as_json) do
      {
        "id" => "1",
        "type" => "TestSerializationParent",
        "attributes" => {
          "test_number" => 50,
          "my_value" => {
            "type" => "MyValue",
            "value" => "52"
          }
        },
        "children" => [
          {
            "id" => "2",
            "type" => "TestSerializationChild",
            "attributes" => {
              "test_string" => "Phone"
            },
            "children" => [
              {
                "id" => "3",
                "type" => "TestSerializationGrandChild",
                "attributes" => {
                  "test_boolean" => false
                },
                "children" => []
              },
              {
                "id" => "4",
                "type" => "TestSerializationGrandChild",
                "attributes" => {
                  "test_boolean" => true
                },
                "children" => []
              }
            ]
          }
        ]
      }
    end

    subject { GameObject::Base.from_as_json(as_json) }

    it "returns the objects" do
      parent = subject
      child = subject.test_serialization_child
      grand_child1 = subject.test_serialization_child.test_serialization_grand_children.first
      grand_child2 = subject.test_serialization_child.test_serialization_grand_children[1]

      expect(parent).to be_a(TestSerializationParent)
      expect(child).to be_a(TestSerializationChild)
      expect(grand_child1).to be_a(TestSerializationGrandChild)
      expect(grand_child2).to be_a(TestSerializationGrandChild)

      expect(parent.id).to eq("1")
      expect(child.id).to eq("2")
      expect(grand_child1.id).to eq("3")
      expect(grand_child2.id).to eq("4")

      expect(parent.test_number).to eq(50)
      expect(child.test_string).to eq("Phone")
      expect(grand_child1.test_boolean).to eq(false)
      expect(grand_child2.test_boolean).to eq(true)
    end
  end

  describe "#as_json" do
    subject { described_instance.as_json }

    let(:described_instance) { TestSerializationParent.new }
    let(:grand_child1){ TestSerializationGrandChild.new }
    let(:grand_child2){ TestSerializationGrandChild.new }
    let(:child){ TestSerializationChild.new }

    before do
      described_instance.test_serialization_child = child
      child.test_serialization_grand_children << grand_child1
      child.test_serialization_grand_children << grand_child2
    end

    let(:default_game_object_attributes) do
      {
        :relative_to_camera=>false,
        :flipped_horizontally=>false,
        :flipped_vertically=>false,
        :renderable=>false,
        :static_renderable=>false,
        :visible=>true,
        :renderable_anchor_point=>{:type=>"Vector", :value=>[0.5, 0.5]},
        :sprite_name=>"OVERRIDE",
        :color=>0,
        :color_blend_factor=>0.0,
        :x_scale=>1.0,
        :y_scale=>1.0,
        :shadow_overlay=>nil,
        :position=>{:type=>"Vector", :value=>[0, 0]},
        :rotation=>{:type=>"Vector", :value=>[0, 1]},
        :z_position=>0,
        :size=>{:type=>"Size", :value=>[0, 0]},
        :tag=>nil
      }
    end

    it "returns a hash of itself, and it's children" do
      expect(subject).to eq(
        {
          id: described_instance.id,
          type: "TestSerializationParent",
          attributes: default_game_object_attributes.merge({
            sprite_name: "test_serialization_parent",
            test_number: 25,
            my_value: {
              type: "MyValue",
              value: 25
            }
          }),
          children: [
            {
              id: child.id,
              type: "TestSerializationChild",
              attributes: default_game_object_attributes.merge({
                sprite_name: "test_serialization_child",
                test_string: "Banana"
              }),
              children: [
                {
                  id: grand_child1.id,
                  type: "TestSerializationGrandChild",
                  attributes: default_game_object_attributes.merge({
                    sprite_name: "test_serialization_grand_child",
                    test_boolean: true
                  }),
                  children: []
                },
                {
                  id: grand_child2.id,
                  type: "TestSerializationGrandChild",
                  attributes: default_game_object_attributes.merge({
                    sprite_name: "test_serialization_grand_child",
                    test_boolean: true
                  }),
                  children: []
                }
              ]
            }
          ]
        }
      )
    end
  end
end
