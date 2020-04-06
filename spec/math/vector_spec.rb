describe Math::Vector do
  describe "#move_towards" do
    let(:current_position) { Vector[1, 1] }
    let(:target_position) { Vector[4, 6] }
    let(:maximum_step) { 9999.0 }
    subject { described_class.move_towards(current_position, target_position, maximum_step) }

    it "returns a vector from current_position to target" do
      expect(subject).to eq(Vector[3, 5])
    end

    context "if the maximum step is larger than the distance" do
      let(:maximum_step) { 1.0 }

      it "returns a shortened vector" do
        expect(subject).to eq(Vector[0.5144957554275265, 0.8574929257125441])
      end
    end

    context "if the speed is minus" do
      let(:maximum_step) { -1.0 }

      it "returns a reversed vector" do
        expect(subject).to eq(Vector[-0.5144957554275265, -0.8574929257125441])
      end
    end
  end
end
