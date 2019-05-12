class FakeParent < GameObject::Base; end
class FakeSubject < GameObject::Base
  belongs_to :fake_parent

  attr_accessor :id
end

describe ManyRelationship do
  let(:parent) { FakeParent.new }
  let(:subject_class) { FakeSubject }
  let(:described_instance) { described_class.new(parent, subject_class) }

  describe "#count" do
    subject { described_instance.count }

    it "returns the elements count" do
      expect(described_instance.count).to eq(0)
      described_instance << FakeSubject.new
      expect(described_instance.count).to eq(1)
    end
  end

  describe "#<<" do
    let(:addition) { FakeSubject.new }
    subject { described_instance << addition }

    it "appends an element" do
      subject
      expect(described_instance.first).to eq(addition)
    end

    it "sets the relationship on the foreign object" do
      subject
      expect(addition.fake_parent).to eq(parent)
    end
  end

  describe "#first" do
    let(:first) { FakeSubject.new }
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

  describe "#each" do
    it "enumerates over each element" do
      first = FakeSubject.new
      second = FakeSubject.new
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

  describe "#select" do
    it "enumerates over each element" do
      first = FakeSubject.new
      second = FakeSubject.new
      described_instance << first
      described_instance << second

      times = 0
      described_instance.select do |element|
        times = times + 1
        expect(element == first || element == second).to eq(true)
      end

      expect(times).to eq(2)
    end

    it "returns a subset of those matching the block expression" do
      first = FakeSubject.new
      second = FakeSubject.new
      described_instance << first
      described_instance << second

      result = described_instance.select { |s| s == first }
      expect(result).to eq([first])
    end
  end

  describe "#map" do
    it "acts like map" do
      first = FakeSubject.new
      second = FakeSubject.new
      described_instance << first
      described_instance << second

      times = 0
      result = described_instance.map do |element|
        times = times + 1
        expect(element == first || element == second).to eq(true)
        "banana#{times}"
      end

      expect(times).to eq(2)
      expect(result).to eq(["banana1", "banana2"])
    end
  end

  describe "#delete" do
    let(:target) { FakeSubject.new }
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

  describe "#to_a" do
    subject { described_instance.to_a }

    before do
      described_instance << FakeSubject.new
    end

    it "creates a copy of the collection as an array" do
      expect(subject).to be_an(Array)
      expect(subject.first).to eq(described_instance.first)
    end

    context "when the copy is changed" do
      let(:copy) { subject }

      before do
        copy << FakeSubject.new
      end

      it "doesn't affect the original" do
        expect(copy.count).to eq(2)
        expect(described_instance.count).to eq(1)
      end
    end
  end

  describe "#[]" do
    it "acts like [] for a collection" do
      a = FakeSubject.new
      b = FakeSubject.new
      described_instance << a
      described_instance << b
      expect(described_instance[0]).to eq(a)
      expect(described_instance[1]).to eq(b)
    end
  end

  describe "#include?" do
    let(:target) { FakeSubject.new }
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

  describe "#find" do
    let(:id) { :one }
    subject { described_instance.find(id) }

    context "when the element exists in the collection" do
      let(:existing_element) { FakeSubject.new }

      before do
        existing_element.id = id
        described_instance << existing_element
      end

      it "returns the element" do
        expect(subject).to eq(existing_element)
      end
    end

    context "when the element does not exist in the collection" do
      before do
        existing_element = FakeSubject.new
        existing_element.id = "some other id"
        described_instance << existing_element
      end

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end
  end
end
