def populate_store
  let(:v_a) { AStar::Vertex.new("a") }
  let(:v_b) { AStar::Vertex.new("b") }
  let(:v_c) { AStar::Vertex.new("c") }
  let(:v_d) { AStar::Vertex.new("d") }

  before do
    described_instance[v_a] = 3.0
    described_instance[v_b] = 1.0
    described_instance[v_c] = 2.0
    described_instance[v_d] = 1.0
  end
end

RSpec.describe AStar::Score do
  let(:described_instance) { described_class.new }

  describe "[]" do
    let(:vertex) { nil }
    subject { described_instance[vertex] }

    context "when nil is supplied" do
      it "returns infinity" do
        expect(subject).to eq(Float::INFINITY)
      end
    end

    context "when the vertex exists in the store" do
      populate_store
      let(:vertex) { v_a }

      it "returns the score for that Vertex" do
        expect(subject).to eq(3.0)
      end
    end

    context "when the vertex doesn't exist in the store" do
      populate_store
      let(:vertex) { AStar::Vertex.new("d") }

      it "returns infinity" do
        expect(subject).to eq(Float::INFINITY)
      end
    end
  end

  describe "[]=" do
    let(:vertex) { AStar::Vertex.new("a") }
    let(:score) { 4.0 }
    subject { described_instance[vertex] = score }

    it "sets the score for a vertex" do
      subject
      expect(described_instance[vertex]).to eq(score)
    end
  end

  describe "lowest_of_verteces" do
    let(:verteces) { nil }
    subject { described_instance.lowest_of_verteces(verteces) }

    context "when nil is supplied" do
      context "when there are vertices in store" do
        populate_store

        it "returns the lowest of all vertices in the store" do
          expect(subject).to eq([v_b, v_d])
        end
      end

      context "when there are no vertices in store" do
        it "returns empty" do
          expect(subject).to eq([])
        end
      end
    end

    context "when verteces are supplied" do
      context "when there are vertices in store" do
        populate_store

        it "returns the lowest" do
          expect(described_instance.lowest_of_verteces([v_a, v_b, v_c]))
            .to eq([v_b])
          expect(described_instance.lowest_of_verteces([v_a, v_c]))
            .to eq([v_c])
          expect(described_instance.lowest_of_verteces([v_a]))
            .to eq([v_a])
        end
      end
    end
  end
end
