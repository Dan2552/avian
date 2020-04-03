RSpec.describe AStar::HeuristicFactory do
  let(:described_instance) { described_class.new }

  describe "#two_dimensional_manhatten_heuristic" do
    subject { described_instance.two_dimensional_manhatten_heuristic }

    it "returns a lamda that can be used to calc heuristic" do
      a = AStar::Vertex.new("a")
      a.info["x"] = 1
      a.info["y"] = 1

      b = AStar::Vertex.new("b")
      b.info["x"] = 5
      b.info["y"] = 2

      expect(subject.call(a, b)).to eq(5)
      expect(subject.call(b, a)).to eq(5)

      c = AStar::Vertex.new("c")
      c.info["x"] = 2
      c.info["y"] = 0

      d = AStar::Vertex.new("d")
      d.info["x"] = 1
      d.info["y"] = 1

      expect(subject.call(c, d)).to eq(2)
      expect(subject.call(d, c)).to eq(2)
    end
  end
end
