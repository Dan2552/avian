RSpec.describe AStar::Graph do
  let(:described_instance) { described_class.new }

  describe "#count" do
    it "returns the number of vertices in the graph" do
      expect(described_instance.count).to eq(0)
      described_instance.add(AStar::Vertex.new("a"))
      expect(described_instance.count).to eq(1)
      described_instance.add(AStar::Vertex.new("b"))
      expect(described_instance.count).to eq(2)
    end
  end

  describe "#==" do
    let(:same) { AStar::Graph.new }

    it "treats the same instance as equal" do
      expect(described_instance == described_instance).to eq(true)
      expect(same == same).to eq(true)
    end

    it "does not treat 2 same-named instances as equal" do
      expect(described_instance == same).to eq(false)
    end
  end

  describe "#add" do
    let(:vertex) { AStar::Vertex.new("a") }
    subject { described_instance.add(vertex) }

    context "when the Vertex is in another graph" do
      before do
        other_graph = AStar::Graph.new
        other_graph.add(vertex)
      end

      it "raises an error" do
        expect { subject }
          .to raise_error("Vertex cannot be in more than one graph.")
      end
    end

    context "when the vertex is not in another graph" do
      it "adds to the graph vertices count" do
        expect { subject }
          .to change { described_instance.count }
          .from(0)
          .to(1)
      end

      it "sets the graph on the vertex" do
        expect { subject }
          .to change { vertex.graph }
          .from(nil)
          .to(described_instance)
      end
    end
  end

  describe "#find" do
    let(:name) { "a" }
    subject { described_instance.find(name) }

    context "when there is a matching vertex" do
      let(:vertex) { AStar::Vertex.new("a") }

      before do
        described_instance.add(vertex)
      end

      it "returns the vertex" do
        expect(subject).to eq(vertex)
      end
    end

    context "when there isn't a match" do
      before do
        described_instance.add(AStar::Vertex.new("b"))
      end

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end
  end

  describe "#remove_vertex_named" do
    let(:name) { "a" }
    subject { described_instance.remove_vertex_named(name) }

    context "when there is a matching vertex" do
      let(:vertex) { AStar::Vertex.new("a") }

      before do
        described_instance.add(vertex)
      end

      it "removes the vertex" do
        expect { subject }
          .to change { described_instance.count }
          .from(1)
          .to(0)
      end

      it "removes the graph from the vertex" do
        expect { subject }
          .to change { vertex.graph }
          .from(described_instance)
          .to(nil)
      end
    end

    context "when there isn't a match" do
      before do
        described_instance.add(AStar::Vertex.new("b"))
      end

      it "doesn't remove a vertex" do
        expect { subject }
          .to_not change { described_instance.count }
      end
    end
  end

  describe "#remove" do
    let(:vertex) { AStar::Vertex.new("a") }
    subject { described_instance.remove(vertex) }

    context "when there is a matching vertex" do
      before do
        described_instance.add(vertex)
      end

      it "removes the vertex" do
        expect { subject }
          .to change { described_instance.count }
          .from(1)
          .to(0)
      end

      it "removes the graph from the vertex" do
        expect { subject }
          .to change { vertex.graph }
          .from(described_instance)
          .to(nil)
      end
    end

    context "when there isn't a match" do
      before do
        described_instance.add(AStar::Vertex.new("b"))
      end

      it "doesn't remove a vertex" do
        expect { subject }
          .to_not change { described_instance.count }
      end
    end
  end

  describe "#unblock_all" do
    subject { described_instance.unblock_all }

    it "sets all the verteces to blocked = false" do
      a = AStar::Vertex.new("a")
      b = AStar::Vertex.new("b")
      c = AStar::Vertex.new("c")
      a.graph = described_instance
      b.graph = described_instance
      c.graph = described_instance
      a.blocked = true
      b.blocked = false
      c.blocked = true

      subject

      expect(a.blocked).to eq(false)
      expect(b.blocked).to eq(false)
      expect(c.blocked).to eq(false)
    end
  end
end
