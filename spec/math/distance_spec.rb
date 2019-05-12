describe Math::Distance do
  describe ".accurate_distance" do
    subject { described_class.accurate_distance(origin, comparison) }

    context "when given two objects at the same location" do
      let(:origin) { double(x: 5, y: 5) }
      let(:comparison) { double(x: 5, y: 5) }

      it "returns 0" do
        expect(subject).to eq(0)
      end
    end

    context "when objects are at a different location to each other" do
      let(:origin) { double(x: 2, y: 2) }
      let(:comparison) { double(x: 4, y: -2) }

      it "returns the distance" do
        expect(subject.round(2)).to eq(4.47)
      end
    end

    context "when something is further away" do
      let(:origin) { double(x: 2, y: 2) }
      let(:comparison) { double(x: 4, y: -2) }

      let(:origin2) { double(x: 2, y: 2) }
      let(:comparison2) { double(x: 4, y: -3) }

      it "returns a higher value" do
        closest = subject
        furthest = described_class.accurate_distance(origin2, comparison2)

        expect(closest < furthest).to eq(true)
      end
    end
  end

  describe ".quick_distance" do
    subject { described_class.quick_distance(origin, comparison) }

    context "when given two objects at the same location" do
      let(:origin) { double(x: 5, y: 5) }
      let(:comparison) { double(x: 5, y: 5) }

      it "returns 0" do
        expect(subject).to eq(0)
      end
    end

    context "when objects are at a different location to each other" do
      let(:origin) { double(x: 2, y: 2) }
      let(:comparison) { double(x: 4, y: -2) }

      it "returns something to the scale of the distance" do
        expect(subject).to eq(20)
      end

      context "when something is further away" do
        let(:origin) { double(x: 2, y: 2) }
        let(:comparison) { double(x: 4, y: -2) }

        let(:origin2) { double(x: 2, y: 2) }
        let(:comparison2) { double(x: 4, y: -3) }

        it "returns a higher value" do
          closest = subject
          furthest = described_class.quick_distance(origin2, comparison2)

          expect(closest < furthest).to eq(true)
        end
      end
    end
  end

  describe ".lowest_distance" do
    let(:closest) { double(x: 3, y: 2) }

    let(:collection) do
      [
        double(x: 3, y: 3),
        double(x: 4, y: 4),
        closest,
        double(x: 5, y: 5),
      ]
    end
    let(:comparison) { double(x: 2, y: 2) }

    subject { described_class.lowest_distance(collection, comparison) }

    it "returns the index of the object with the lowest distance to the comparison" do
      expect(subject).to eq(2)
    end

    context "when the comparison is included within the collection" do
      before do
        collection << comparison
      end

      it "is ignored" do
        expect(subject).to eq(2)
      end
    end

    context "when the comparison is `==` with a value in the collection" do
      let(:closest) { Vector[3,2] }
      let(:comparison){ Vector[3,2] }

      let(:collection) do
        [
          closest
        ]
      end

      before do
        expect(closest == comparison).to eq(true)
      end

      it "is not ignored" do
        expect(subject).to eq(0)
      end
    end
  end
end
