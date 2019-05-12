module Specs
  module GameObject
    class One < ::GameObject::Base
      has_many :twos
      has_one :three
    end

    class Two < ::GameObject::Base
      belongs_to :one
    end

    class Three < ::GameObject::Base
      belongs_to :one
    end
  end
end

class GameObject::ASubclassOfGameObjectBase < GameObject::Base; end
class GameObject::AnotherSubclassForPluralCheck < GameObject::Base; end

describe GameObject::Base do
  describe ".foreign_relationship_name" do

    subject { described_class.foreign_relationship_name }

    it "returns the relationship name" do
      expect(subject).to eq("base")
    end

    context "when a subclass" do
      subject { GameObject::ASubclassOfGameObjectBase.foreign_relationship_name }

      it "has it's own name" do
        expect(subject).to eq("a_subclass_of_game_object_base")
      end
    end
  end

  describe ".class_for" do
    let(:relationship_name) { "base" }
    subject { described_class.class_for(relationship_name, false) }

    it "returns the class for a given relationship name" do
      expect(subject).to eq(GameObject::Base)
    end

    context "subclass name" do
      let(:relationship_name) { "a_subclass_of_game_object_base" }

      it "returns the class for a given relationship name" do
        expect(subject).to eq(GameObject::ASubclassOfGameObjectBase)
      end
    end

    context "plural" do
      let(:relationship_name) { "another_subclass_for_plural_checks" }
      subject { described_class.class_for(relationship_name, true) }

      it "returns the class for a given relationship name" do
        expect(subject).to eq(GameObject::AnotherSubclassForPluralCheck)
      end
    end
  end

  describe ".has_many" do
    let(:described_instance) { Specs::GameObject::One.new }

    it "defines a to-many relationship" do
      expect(described_instance.twos.count).to eq(0)
      two = Specs::GameObject::Two.new
      described_instance.twos << two
      expect(described_instance.twos.count).to eq(1)
      expect(described_instance.twos.first).to eq(two)
    end
  end

  describe ".has_one" do
    let(:described_instance) { Specs::GameObject::One.new }

    it "defines a singular relationship" do
      expect(described_instance.three).to eq(nil)
      three = Specs::GameObject::Three.new
      described_instance.three = three
      expect(described_instance.three).to eq(three)
    end

    it "defines an instance variable on the subject class" do
      three = Specs::GameObject::Three.new
      described_instance.three = three
      expect(three.instance_variable_get(:"@one")).to eq(described_instance)
    end
  end

  describe ".belongs_to" do
    let(:described_instance) { Specs::GameObject::Two.new }

    it "defines an accessor" do
      expect(described_instance.one).to eq(nil)
      described_instance.instance_variable_set(:"@one", 1)
      expect(described_instance.one).to eq(1)
    end
  end

  describe ".child_relationships" do
    subject { Specs::GameObject::One.child_relationships }

    it "returns the names of the child relationships" do
      expect(subject).to eq([:twos, :three])
    end

    context "when there are parent relationships" do
      subject { Specs::GameObject::Two.child_relationships }

      it "does not include the parent relationships" do
        expect(subject).to eq([])
      end
    end
  end

  describe ".parent_relationships" do
    subject { Specs::GameObject::Two.parent_relationships }

    it "returns the names of the parent relationships" do
      expect(subject).to eq([:one])
    end

    context "when there are child relationships" do
      subject { Specs::GameObject::One.parent_relationships }

      it "does not include the child relationships" do
        expect(subject).to eq([])
      end
    end
  end
end
