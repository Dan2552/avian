describe Avian::Tiled::TileLayer do
  let(:described_instance) do
    fixture_path = Bundler.root.join("spec", "engine", "tiled", "fixtures", "one.json")
    Avian::Tiled::Map.new(JSON.parse(File.read(fixture_path))).layers.first
  end

  describe "#each_tile" do
    subject do
      output = []
      described_instance.each_tile do |x, y, tile|
        output << [x, y, tile]
      end
      output
    end

    it "iterates over each tile, giving x and y positions and tile index" do
      expect(subject[0]).to eq([0, 0, 0])
      expect(subject[1]).to eq([1, 0, 0])

      # width is 36
      # height is 30
      expect(subject.count).to eq(30 * 36)

      expect(subject[35]).to eq([35, 0, 0])
      expect(subject[36]).to eq([0, 1, 0])
      expect(subject[37]).to eq([1, 1, 0])

      # something with a tile value
      expect(subject[149]).to eq([5, 4, 20])
    end
  end

  describe "#[]" do
    let(:key) { "height" }
    subject { described_instance[key] }

    it "exposes the underlying hash values" do
      expect(subject).to eq(30)
    end
  end
end
