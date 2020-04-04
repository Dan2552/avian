RSpec.describe AStar::Vertex do
  let(:described_instance) { AStar::Vertex.new("a") }

  describe "#x" do
    subject { described_instance.x }

    context "by default" do
      it "is nil" do
        expect(subject).to eq(nil)
      end
    end

    context "when initialized with a value" do
      let(:described_instance) { AStar::Vertex.new("a", 1, 2) }

      it "returns the value" do
        expect(subject).to eq(1)
      end
    end
  end

  describe "#y" do
    subject { described_instance.y }

    context "by default" do
      it "is nil" do
        expect(subject).to eq(nil)
      end
    end

    context "when initialized with a value" do
      let(:described_instance) { AStar::Vertex.new("a", 1, 2) }

      it "returns the value" do
        expect(subject).to eq(2)
      end
    end
  end

  describe "#==" do
    let(:same) { AStar::Vertex.new("a") }

    it "treats the same instance as equal" do
      expect(described_instance == described_instance).to eq(true)
      expect(same == same).to eq(true)
    end

    it "does not treat 2 same-named instances as equal" do
      expect(described_instance == same).to eq(false)
    end
  end

  describe "#add_neighbor" do
    let(:vertex) { AStar::Vertex.new("b") }
    subject { described_instance.add_neighbor(vertex) }

    context "when the neighbor is on the graph" do
      before do
        graph = AStar::Graph.new
        described_instance.graph = graph
        vertex.graph = graph
      end

      it "adds the neighbor" do
        subject
        expect(described_instance.neighbors).to include(vertex)
        expect(vertex.neighbors).to include(described_instance)
      end
    end

    context "when the neighbor is not on the same graph" do
      before do
        described_instance.graph = AStar::Graph.new
        vertex.graph = AStar::Graph.new
      end

      it "raises" do
        expect { subject }
          .to raise_error("Verteces must be in the same graph to be linked up.")
      end
    end

    context "when the vertex is not on a graph" do
      it "raises" do
        expect { subject }
          .to raise_error("Verteces must be in the same graph to be linked up.")
      end
    end
  end

  describe "#remove_neighbor" do
    let(:vertex) { AStar::Vertex.new("b") }
    subject { described_instance.remove_neighbor(vertex) }

    context "when the verteces are neighbors" do
      before do
        graph = AStar::Graph.new
        described_instance.graph = graph
        vertex.graph = graph
        described_instance.add_neighbor(vertex)
      end

      it "removes the neighbor from the described_instance" do
        expect { subject }
          .to change { described_instance.neighbors.include?(vertex) }
          .from(true)
          .to(false)
      end

      it "removes the neighbor from the vertex" do
        expect { subject }
          .to change { vertex.neighbors.include?(described_instance) }
          .from(true)
          .to(false)
      end
    end
  end

  describe "#remove_all_neighbors" do
    subject { described_instance.remove_all_neighbors }

    context "when there are neighbors" do
      before do
        graph = AStar::Graph.new
        described_instance.graph = graph

        ["b", "c", "d"]
          .map { |e| AStar::Vertex.new(e) }
          .each { |e| e.graph = graph; described_instance.add_neighbor(e) }
      end

      it "removes all the neighbors" do
        expect { subject }
          .to change { described_instance.neighbors.count }
          .from(3)
          .to(0)
      end

      it "removes itself from the neighbors' neighbors" do
        n1 = described_instance.neighbors.first
        expect { subject }
          .to change { n1.neighbors.include?(described_instance) }
          .from(true)
          .to(false)
      end
    end
  end

  describe "#blocked / #blocked=" do
    it "defaults to false" do
      expect(described_instance.blocked).to eq(false)
    end

    it "is settable" do
      described_instance.blocked = true
      expect(described_instance.blocked).to eq(true)
    end
  end

  describe "#graph=" do
    let(:graph) { nil }
    subject { described_instance.graph = graph }

    context "when setting to a graph" do
      let(:graph) { AStar::Graph.new }

      it "adds itself to the graph" do
        expect(graph)
          .to receive(:add)
          .with(described_instance)

        subject
      end

      it "sets #graph" do
        expect { subject }
          .to change { described_instance.graph }
          .from(nil)
          .to(graph)
      end
    end

    context "when setting to nil" do
      context "when there are neighbors" do
        before do
          vertex = AStar::Vertex.new("b")
          graph = AStar::Graph.new
          described_instance.graph = graph
          vertex.graph = graph
          described_instance.add_neighbor(vertex)
        end

        it "removes the neighbors" do
          expect { subject }
            .to change { described_instance.neighbors.count }
            .from(1)
            .to(0)
        end

        it "sets #graph" do
          subject
          expect(described_instance.graph).to eq(nil)
        end
      end
    end
  end
end
