describe RenderList do
  let(:described_instance) { described_class.new }

  describe ".shared_instance" do
    it "always returns the same instance" do
      one = described_class.shared_instance
      two = described_class.shared_instance
      expect(one.equal?(two)).to eq(true)
    end
  end

  describe "#clear!" do
    subject { described_instance.clear! }

    it "removes all children" do
      has_run = false
      described_instance.each do |go|
        has_run = true
      end

      expect(has_run).to eq(false)
    end
  end

  describe "#<<" do
    let(:game_object) { double(renderable?: true) }
    subject { described_instance << game_object }

    context "when the object is renderable" do
      before do
        expect(game_object.renderable?).to eq(true)
      end

      it "adds the object to the list" do
        subject

        has_run = false
        described_instance.each do |go|
          has_run = true
          expect(go).to eq(game_object)
        end

        expect(has_run).to eq(true)
      end
    end

    context "when the object is not renderable" do
      let(:game_object) { double(renderable?: false) }

      it "raises" do
        expect { subject }.to raise_error("#{game_object} is not renderable")
      end
    end
  end
end
