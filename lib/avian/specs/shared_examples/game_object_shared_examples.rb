shared_examples_for("a game object") do
  it "is a GameObject" do
    expect(described_instance).to be_a(GameObject::Base)
  end

  it_has_a_vector(:position)
  it_has_a_vector(:rotation)

  it_has_an_accessor(:relative_to_camera, Boolean)
  it_has_a_vector(:position)

  it_has_a_vector :size

  describe "#frame" do
    subject { described_instance.frame }

    context "when the object has a size" do
      before do
        described_instance.size = Size[2, 2]
      end

      it "returns a rectangle" do
        expect(subject).to be_a(Rectangle)
      end

      it "has the origin at the bottom-left of the object" do
        # -(size / 2) because it's the bottom left of the rect
        expect(subject.origin.x).to eq(described_instance.position.x - 1)
        expect(subject.origin.y).to eq(described_instance.position.y - 1)
      end

      it "has the size of the object" do
        expect(subject.size.width).to eq(2)
        expect(subject.size.height).to eq(2)
      end

      context "when the object has a non-central renderable_anchor_point" do
        before do
          described_instance.renderable_anchor_point = Vector[0, 0]
        end

        it "has the origin at the bottom-left of the object" do
          expect(subject.origin.x).to eq(described_instance.position.x)
          expect(subject.origin.y).to eq(described_instance.position.y)
        end

        it "has the size of the object" do
          expect(subject.size.width).to eq(2)
          expect(subject.size.height).to eq(2)
        end
      end
    end
  end

  describe "#id" do
    subject { described_instance.id }

    it "returns a uuid" do
      matches = !!subject.match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/)
      expect(matches).to eq(true)
    end
  end

  describe "#inspect" do
    subject { described_instance.inspect }

    it "includes the class name" do
      expect(subject).to include(described_instance.class.to_s)
    end

    it "includes a shortened version of the object's id" do
      expect(subject).to include(described_instance.id[0..4])
    end
  end

  describe "#destroy" do
    subject { described_instance.destroy }

    it "returns true" do
      expect(subject).to eq(true)
    end

    it "sets #destroyed? as true" do
      expect(described_instance.destroyed?).to eq(false)
      subject
      expect(described_instance.destroyed?).to eq(true)
    end

    it "removes from one-to-many belongs to associations" do
      # i.e. if described_instance is an GameObject::Engine, this'd be "engine"
      foreign_relationship_name = described_instance.class.send(:foreign_relationship_name)

      # Set up the relationships
      described_class.parent_relationships.each do |relationship|
        parent = OpenStruct.new("#{foreign_relationship_name}s": [])

        parent.send("#{foreign_relationship_name}s") << described_instance

        expect(parent.send(:"#{foreign_relationship_name}s"))
          .to include(described_instance)

        described_instance.instance_variable_set(:"@#{relationship}", parent)
      end

      subject

      described_class.parent_relationships.each do |relationship|
        parent = described_instance.send(relationship)

        expect(parent.send(:"#{foreign_relationship_name}s"))
          .to_not include(described_instance)
      end
    end

    it "removes from one-to-one belongs_to associations" do
      # i.e. if described_instance is an GameObject::Engine, this'd be "engine"
      foreign_relationship_name = described_instance.class.send(:foreign_relationship_name)

      # Set up the relationships
      described_class.parent_relationships.each do |relationship|
        parent = OpenStruct.new("#{foreign_relationship_name}": nil)

        parent.send("#{foreign_relationship_name}=", described_instance)
        expect(parent.send(:"#{foreign_relationship_name}"))
          .to eq(described_instance)

        described_instance.instance_variable_set(:"@#{relationship}", parent)
      end

      subject

      # Check the relationships are killed
      described_class.parent_relationships.each do |relationship|
        parent = described_instance.send(relationship)

        expect(parent.send(:"#{foreign_relationship_name}"))
          .to eq(nil)
      end
    end
  end

  describe "#perform_update" do
    subject { described_instance.perform_update }
    disable_all_updates_except(:described_instance)

    context "when the GameObject is destroyed" do
      before { described_instance.destroy }

      context "first time" do
        it "does nothing special" do
          expect { subject }.to_not raise_error
        end
      end
      context "second time" do
        before do
          described_instance.perform_update
        end

        it "raises an exception" do
          expect { subject }.to raise_error("#perform_update called on destroyed GameObject")
        end
      end
    end

    context "when the GameObject is renderable" do
      it "adds to the render list" do
        if described_instance.renderable?
          allow(described_instance)
            .to receive(:update)
            .and_return(nil)

          expect(RenderList.shared_instance)
            .to receive(:<<)
            .with(described_instance)

          subject
        end
      end
    end

    context "when the GameObject is not renderable" do
      it "does not add to the render list" do
        unless described_instance.renderable?
          allow(described_instance)
            .to receive(:update)
            .and_return(nil)

          expect(RenderList.shared_instance)
            .to_not receive(:<<)
            .with(described_instance)

          subject
        end
      end
    end

    context "when the GameObject has children" do
      it "performs update on each child" do
        allow(described_instance)
          .to receive(:update)
          .and_return(nil)

        described_class.child_relationships.each do |relationship|
          relationship_double = double('relationship_double', is_a?: true)
          if described_instance.respond_to?(:"#{relationship}=")
            described_instance.send(:"#{relationship}=", relationship_double)
          else
            described_instance.send(:"#{relationship}") << relationship_double
          end
          expect(relationship_double)
            .to receive(:perform_update)
        end

        subject
      end
    end

    context "when the GameObject has parents" do
      it "does not perform update on parents" do
        allow(described_instance)
          .to receive(:update)
          .and_return(nil)

        described_class.parent_relationships.each do |relationship|
          relationship_double = double('relationship_double', is_a?: true)
          if described_instance.respond_to?(:"#{relationship}")
            described_instance.instance_variable_set(:"@#{relationship}", relationship_double)
          end
          expect(relationship_double)
            .to_not receive(:perform_update)
        end

        subject
      end
    end
  end
end
