class GameObject::Flea < GameObject::Base
  belongs_to :dog
end

class GameObject::Hair < GameObject::Base
  belongs_to :tree
end

class GameObject::Dog < GameObject::Base
  has_many :fleas
  has_many :hairs
end

describe GameObject::Base do
  let(:described_instance) { described_class.new }

  it_behaves_like "a game object"

  describe "#sprite_name" do
    subject { described_instance.sprite_name }

    it "defaults to the name of the game object class" do
      expect(subject).to eq(described_class.to_s.split("::").last.underscore.downcase)
    end
  end

  describe "#renderable?" do
    subject { described_instance.renderable? }

    it "defaults to false" do
      expect(subject).to eq(false)
    end
  end
end

describe GameObject::Dog do
  let(:described_instance) { described_class.new }

  xdescribe "#each_child" do
    subject { described_instance.children }

    it "returns an array of children relations" do
      expect(subject).to be_an(Array)
    end

    context "without any children" do
      before do
        expect(described_instance.hairs.count).to eq(0)
        expect(described_instance.fleas.count).to eq(0)
      end

      it "returns an empty array" do
        expect(subject.count).to eq(0)
      end
    end

    context "when there are child relationships" do
      let(:child1) { GameObject::Hair.new }
      let(:child2) { GameObject::Hair.new }
      let(:child3) { GameObject::Flea.new }

      before do
        described_instance.hairs << child1
        described_instance.hairs << child2
        described_instance.fleas << child3
      end

      it "returns the children" do
        result = subject.sort_by { |x| x.id }
        expectation = [child1, child2, child3].sort_by { |x| x.id }
        expect(result).to eq(expectation)
      end
    end
  end
end
