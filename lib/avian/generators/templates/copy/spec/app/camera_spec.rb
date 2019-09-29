describe Camera do
  let(:described_instance) { described_class.new }

  it_behaves_like "a game object"

  it_has_an_accessor :scale, Integer

  describe "#scale" do
    subject { described_instance.scale }

    it "defaults to 2" do
      expect(subject).to eq(2)
    end
  end

  describe "#scale=" do
    let(:new_value) { 1 }
    subject { described_instance.scale = new_value }

    context "when setting a value lower than 1" do
      let(:new_value) { 0 }

      it "does not set the value" do
        previous_scale = described_instance.scale
        subject
        expect(described_instance.scale).to eq(previous_scale)
      end
    end

    context "when setting a value higher than 1" do
      let(:new_value) { 4 }

      it "sets the value" do
        subject
        expect(described_instance.scale).to eq(new_value)
      end

      it "changes the size to match the scale" do
        old_size = described_instance.size.dup
        subject
        expect(described_instance.size.width).to eq(old_size.width * 2)
        expect(described_instance.size.height).to eq(old_size.height * 2)
      end
    end
  end

  describe "#perform_update" do
    before { Time.delta = 1 }
    subject { described_instance.perform_update }
    disable_all_updates_except(:described_instance)

    context "when the camera has a target" do
      before do
        described_instance.target = double(is_a?: true, position: Vector[10, 10])
      end

      it "moves the camera to the same position as the camera" do
        expect { subject }
          .to change { described_instance.position }
          .from(Vector[0,0])
          .to(Vector[10, 10])
      end
    end
  end

  describe "#screen_position_in_scene" do
    let(:position) { Vector[10, 10] }
    subject { described_instance.screen_position_in_scene(position) }

    it "returns the position in the scene" do
      expect(subject).to eq(Vector[-955.0, -647.0])
    end

    context "when the camera is at a different position" do
      before do
        described_instance.position += Vector[10, 10]
      end

      it "returns a different value" do
        expect(subject).to eq(Vector[-945.0, -637.0])
      end
    end

    context "when the camera is at a different scale" do
      before do
        described_instance.scale = 4
      end

      it "returns a different value" do
        expect(subject).to eq(Vector[-1910.0, -1294.0])
      end
    end
  end
end
