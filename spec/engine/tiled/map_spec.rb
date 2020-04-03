describe Avian::Tiled::Map do
  let(:described_instance) do
    fixture_path = Bundler.root.join("spec", "engine", "tiled", "fixtures", "one.json")
    described_class.new(JSON.parse(File.read(fixture_path)))
  end

  describe "#layers" do
    subject { described_instance.layers }

    it "returns a collection of layers" do
      expect(subject.count).to eq(4)
      expect(subject[0]).to be_a(Avian::Tiled::TileLayer)
      expect(subject[1]).to be_a(Avian::Tiled::TileLayer)
      expect(subject[2]).to be_a(Avian::Tiled::ObjectLayer)
      expect(subject[3]).to be_a(Avian::Tiled::TileLayer)
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
