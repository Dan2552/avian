describe Collisions::Cell do
  let(:row) { 1 }
  let(:col) { 1 }
  let(:described_instance) { described_class.new(row, col) }
  it_has_a_reader(:row)
  it_has_a_reader(:col)

  describe "#<<" do
    let(:addition) { GameObject::Base.new }
    subject { described_instance << addition }

    it "appends an element" do
      subject
      expect(described_instance.all.first).to eq(addition)
    end
  end


  describe "#delete" do
    let(:target) { GameObject::Base.new }
    subject { described_instance.delete(target) }

    before do
      described_instance << target
    end

    it "deletes the given element" do
      expect(described_instance.all.count).to eq(1)
      subject
      expect(described_instance.all.count).to eq(0)
    end
  end

  describe "#all" do
    # See #<<
    # See #delete
  end
end
