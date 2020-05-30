describe Loop do
  let(:root_object) { double(perform_update: 0) }
  let(:described_instance) { described_class.new(root_object) }

  describe "#update" do
    let(:current_time) { 1737681.899217 }
    subject { described_instance.perform_update(current_time) }

    before do
      allow_any_instance_of(Renderer)
        .to receive(:draw_frame)
    end

    it "calls to the renderer to draw a frame" do
      expect_any_instance_of(Renderer)
        .to receive(:draw_frame)

      subject
    end

    it "clears the render list" do
      expect(RenderList.shared_instance).to receive(:clear!)

      subject
    end

    context "when called for the first time" do
      it "calls the root_object" do
        expect(root_object).to receive(:perform_update)

        subject
      end

      it "calls the sets the lowest delta" do
        subject

        expect(Time.delta).to eq(0.008)
      end
    end

    context "when called for the 2nd time" do
      let(:first_time) { 1737681.899217 }
      let(:current_time) { 1737748.565885 }

      before do
        described_instance.perform_update(first_time)
      end

      it "calls the root_object perform_update with the difference in seconds as delta" do
        subject

        expect(Time.delta).to eq(0.06666666799993254)
      end

      context "when the difference is less than 8ms" do
        let(:current_time) { first_time + 6 }

        it "calls the sets the lowest delta" do
          subject

          expect(Time.delta).to eq(0.008)
        end
      end
    end
  end
end
