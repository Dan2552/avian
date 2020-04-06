describe Collision::IncrementalMovement do
  let(:game_object) { GameObject::Base.new }
  let(:increment) { 0.1 }
  let(:described_instance) { described_class.new(game_object, increment) }

  before do
    game_object.size = Size[1, 1]
  end

  describe "#move" do
    let(:collision_check) { Proc.new { true } }

    subject do
      described_instance.move(vector, &collision_check)
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

      it "puts the player's position as moved by vector" do
        expect { subject }
          .to change { game_object.position }
          .from(Vector[0, 0])
          .to(vector)
      end

      context "when collision occurs" do
        let(:collision_check) { Proc.new { game_object.position.y < 0.5 } }

        it "puts the player's position at the iteration before it collides" do
          expect { subject }
            .to change { game_object.position }
            .from(Vector[0, 0])
            .to(Vector[0, 0.4])
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

      it "puts the player's position as moved by vector" do
        expect { subject }
          .to change { game_object.position }
          .from(Vector[0, 0])
          .to(vector)
      end

      context "when collision occurs" do
        let(:collision_check) { Proc.new { game_object.position.x < 0.5 } }

        it "puts the player's position at the iteration before it collides" do
          expect { subject }
            .to change { game_object.position }
            .from(Vector[0, 0])
            .to(Vector[0.4, 0])
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

      it "puts the player's position as moved by vector" do
        expect { subject }
          .to change { game_object.position }
          .from(Vector[0, 0])
          .to(vector)
      end

      context "when collision occurs" do
        let(:collision_check) { Proc.new { game_object.position.y > -0.5 } }

        it "puts the player's position at the iteration before it collides" do
          expect { subject }
            .to change { game_object.position }
            .from(Vector[0, 0])
            .to(Vector[0, -0.4])
        end
      end
    end
  end
end
