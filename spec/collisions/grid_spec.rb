describe Collisions::Grid do
  let(:size) { Size[6, 6] }
  let(:cell_size) { Size[2, 2] }
  let(:described_instance) { described_class.new(size, cell_size) }

  describe "#add!" do
    let(:game_object) { GameObject::Base.new }
    subject { described_instance.add!(game_object) }

    context "when the size of the object is zero" do
      before do
        expect(game_object.size.zero?).to eq(true)
      end

      it "raises an exception" do
        expect { subject }
          .to raise_error("A game object that has no size cannot be added to a collision grid")
      end
    end

    context "when the size of the object is non-zero" do
      before do
        game_object.size = Size[10, 10]
      end

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end
  end

  describe "#move!" do
    xit "..."
  end

  describe "#remove!" do
    xit "..."
  end

  describe "#nearest_objects_for" do
    let(:game_object) do
      game_object = GameObject::Base.new
      game_object.size = Size[10, 10]
      game_object
    end
    let(:depth) { 0 }

    subject { described_instance.nearest_objects_for(game_object, depth) }

    context "when no objects have been added" do
      it "returns an empty array" do
        expect(subject).to eq([])
      end
    end

    context "when the game object has been added, but nothing else has" do
      before do
        described_instance.add!(game_object)
      end

      it "returns an empty array" do
        expect(subject).to eq([])
      end
    end

    context "when objects have been added but are not within the depth" do
      let(:size) { Size[6, 6] }
      let(:cell_size) { Size[2, 2] }
      let(:another1) { GameObject::Base.new }
      let(:another2) { GameObject::Base.new }

      before do
        game_object.size = Size[1, 1]
        another1.size = Size[1, 1]
        another2.size = Size[1, 1]

        game_object.position = Vector[2.5, 2.5]
        another1.position = Vector[1.5, 5.5]
        another2.position = Vector[2.5, 4.5]

        described_instance.add!(another1)
        described_instance.add!(another2)
      end

      it "returns an empty array" do
        expect(subject).to eq([])
      end
    end

    context "when objects have been added and are within the depth" do
      let(:size) { Size[6, 6] }
      let(:cell_size) { Size[2, 2] }
      let(:another1) { GameObject::Base.new }
      let(:another2) { GameObject::Base.new }

      before do
        game_object.size = Size[1, 1]
        another1.size = Size[1, 1]
        another2.size = Size[1, 1]

        game_object.position = Vector[2.5, 2.5]
        another1.position = Vector[3.5, 3.5]
        another2.position = Vector[2.5, 4.5]

        described_instance.add!(another1)
        described_instance.add!(another2)
      end

      context "with 0 depth" do
        let(:depth) { 0 }

        it "returns the objects in depth" do
          expect(subject).to include(another1)
        end

        it "does not return objects not in depth" do
          expect(subject).to_not include(another2)
        end
      end

      context "with 1 depth" do
        let(:depth) { 1 }

        it "returns the objects in depth" do
          expect(subject).to include(another1, another2)
        end
      end
    end
  end
end
