RSpec.describe AStar::GraphFactory do
  let(:described_instance) { described_class }

  describe "#two_dimensional_graph" do
    let(:width) { 3 }
    let(:height) { 3 }
    subject { described_instance.two_dimensional_graph(width, height) }

    it "returns a graph with the correct amount of verteces" do
      expect(subject.count).to eq(9)
    end

    it "constructs the neighbors" do
      middle = subject.find("1,1")
      u = subject.find("1,0")
      d = subject.find("1,2")
      l = subject.find("0,1")
      r = subject.find("2,1")

      expect(middle.neighbors.count).to eq(4)
      expect(middle.neighbors).to include(u)
      expect(middle.neighbors).to include(d)
      expect(middle.neighbors).to include(l)
      expect(middle.neighbors).to include(r)

      expect(u.neighbors).to include(middle)
      expect(d.neighbors).to include(middle)
      expect(l.neighbors).to include(middle)
      expect(r.neighbors).to include(middle)
    end

    it "correctly names all the verteces" do
      verteces = [
        "0,0", "0,1", "0,2",
        "1,0", "1,1", "1,2",
        "2,0", "2,1", "2,2"
      ].map { |name| subject.find(name) }

      expect(verteces.compact.count).to eq(9)
    end

    it "populates the info for each vertex" do
      one_two = subject.find("1,2")
      expect(one_two.x).to eq(1)
      expect(one_two.y).to eq(2)

      zero_two = subject.find("0,2")

      expect(zero_two.x).to eq(0)
      expect(zero_two.y).to eq(2)
    end
  end
end
