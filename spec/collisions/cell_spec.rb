describe Collisions::Cell do
  let(:row) { 1 }
  let(:col) { 1 }
  let(:described_instance) { described_class.new(row, col) }
  it_has_a_reader(:row)
  it_has_a_reader(:col)

  describe "#count" do
    subject { described_instance.count }

    it "returns the elements count" do
      expect(described_instance.count).to eq(0)
      described_instance << double
      expect(described_instance.count).to eq(1)
    end
  end

  describe "#include?" do
    let(:target) { double }
    subject { described_instance.include?(target) }

    context "when the element is included" do
      before do
        described_instance << target
      end

      it "returns true" do
        expect(subject).to eq(true)
      end
    end

    context "when the element is not included" do
      it "returns false" do
        expect(subject).to eq(false)
      end
    end
  end


  describe "#first" do
    let(:first) { double }
    subject { described_instance.first }

    context "when there are elements" do
      before do
        described_instance << first
      end

      it "returns the first element" do
        expect(subject).to eq(first)
      end
    end
  end

  describe "#<<" do
    let(:addition) { double }
    subject { described_instance << addition }

    it "appends an element" do
      subject
      expect(described_instance.first).to eq(addition)
    end
  end

  describe "#each" do
    it "enumerates over each element" do
      first = double
      second = double
      described_instance << first
      described_instance << second

      times = 0
      described_instance.each do |element|
        times = times + 1
        expect(element == first || element == second).to eq(true)
      end

      expect(times).to eq(2)
    end
  end

  describe "#delete" do
    let(:target) { double }
    subject { described_instance.delete(target) }

    before do
      described_instance << target
    end

    it "deletes the given element" do
      expect(described_instance.count).to eq(1)
      subject
      expect(described_instance.count).to eq(0)
    end
  end
end
