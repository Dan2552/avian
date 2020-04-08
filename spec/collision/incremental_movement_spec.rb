describe Collision::IncrementalMovement do
  let(:increment) { 0.1 }
  let(:described_instance) { described_class.new(current_position, increment) }

  describe "#reduce_vector" do
    let(:current_position) { Vector[0, 0] }
    let(:collision_check) { Proc.new { true } }

    subject do
      described_instance.reduce_vector(vector, &collision_check)
    end

    context "when moving up" do
      let(:vector) { Vector[0, 1] }

      it "checks collision 10 times" do
        expect(collision_check)
          .to receive(:call)
          .exactly(10)
          .times
          .and_return(true)

        subject
      end

      it "returns the vector" do
        expect(subject).to eq(vector)
      end

      context "when collision occurs" do
        let(:collision_check) do
          -> (potential_position) { potential_position.y < 0.5 }
        end

        it "shorten's the vector to the iteration before it collides" do
          expect(subject).to eq(Vector[0, 0.4])
        end
      end
    end

    context "when moving right" do
      let(:vector) { Vector[1, 0] }

      it "checks collision 10 times" do
        expect(collision_check)
          .to receive(:call)
          .exactly(10)
          .times
          .and_return(true)

        subject
      end

      it "returns the vector" do
        expect(subject).to eq(vector)
      end

      context "when collision occurs" do
        let(:collision_check) do
          -> (potential_position) { potential_position.x < 0.5 }
        end

        it "shorten's the vector to the iteration before it collides" do
          expect(subject).to eq(Vector[0.4, 0])
        end
      end
    end

    context "when moving down" do
      let(:vector) { Vector[0, -1] }

      it "checks collision 10 times" do
        expect(collision_check)
          .to receive(:call)
          .exactly(10)
          .times
          .and_return(true)

        subject
      end

      it "returns the vector" do
        expect(subject).to eq(vector)
      end

      context "when collision occurs" do
        let(:collision_check) do
          -> (potential_position) { potential_position.y > -0.5 }
        end

        it "reduces the vector to the iteration before it collides" do
          expect(subject).to eq(Vector[0, -0.4])
        end
      end
    end
  end
end
