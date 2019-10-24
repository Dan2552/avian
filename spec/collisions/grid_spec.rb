describe Collisions::Grid do
  let(:size) { Size[4, 4] }
  let(:cell_size) { Size[2, 2] }
  let(:origin) { Vector[0, 0] }
  let(:described_instance) { described_class.new(size, cell_size, origin) }

  describe "#nearest_objects_to" do
    let(:game_object) { GameObject::Base.new }
    subject { described_instance.nearest_objects_to(game_object, 1) }

    context "when no objects have been added" do
      it "raises that the supplied game object is not in the grid" do
        expect { subject }
          .to raise_error(
            "The supplied GameObject::Base has not been added to the grid"
          )
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

    context "when the game object has been added, but other objects are not within the depth" do
      before do
        described_instance.add!(game_object)

      end

      it "returns an empty array" do
        expect(subject).to eq([])
      end
    end
  end
end

# fdescribe Collisions::Grid do
#   let(:owner_frame) do
#     Rectangle.new(Vector[10, 10], Size.new(20, 20))
#   end
#   let(:owner_size) do
#     Size.new(200, 200)
#   end

#   let(:owner) { double("owner", frame: owner_frame, size: owner_size) }
#   let(:size) { Size.new(10, 10) }
#   let(:described_instance) { described_class.new(owner, size) }

#   describe "#at" do
#     let(:x) { 0 }
#     let(:y) { 0 }
#     subject { described_instance.at(x, y) }

#     context "when in range" do
#       let(:x) { 0 }
#       let(:y) { 0 }

#       it "returns a Cell" do
#         expect(subject).to be_a(Collisions::Cell)
#       end

#       context "when mutating the array" do
#         before do
#           arr = described_instance.at(x, y)
#           arr << "Something"
#         end

#         it "returns the mutated array" do
#           expect(subject.first).to eq("Something")
#         end
#       end
#     end

#     context "when negative x" do
#       let(:x) { -1 }

#       it "raises an exception" do
#         expect { subject }.to raise_error(Collisions::Grid::OutOfBounds, "(-1, 0)")
#       end
#     end

#     context "when negative y" do
#       let(:y) { -1 }

#       it "raises an exception" do
#         expect { subject }.to raise_error(Collisions::Grid::OutOfBounds, "(0, -1)")
#       end
#     end

#     context "when higher than size width" do
#       let(:x) { 10 }

#       it "raises an exception" do
#         expect { subject }.to raise_error(Collisions::Grid::OutOfBounds, "(10, 0)")
#       end
#     end

#     context "when highter than size height" do
#       let(:y) { 10 }

#       it "raises an exception" do
#         expect { subject }.to raise_error(Collisions::Grid::OutOfBounds, "(0, 10)")
#       end
#     end
#   end

#   describe "#cell_for_position" do
#     let(:position) { raise "override" }
#     subject { described_instance.cell_for_position(position) }

#     context "when the position is outside of the frame" do
#       context "x is less than frame bounds" do
#         let(:position) { Vector[0, 10] }

#         it "returns nil" do
#           expect(subject).to eq(nil)
#         end
#       end

#       context "x is higher than frame bounds" do
#         let(:position) { Vector[211, 10] }

#         it "returns nil" do
#           expect(subject).to eq(nil)
#         end
#       end
#     end

#     context "when the position is inside the frame" do
#       let(:position) { Vector[10, 10] }

#       it "returns the cell for the given position relative to the owner" do
#         subject
#       end
#     end
#   end
# end
