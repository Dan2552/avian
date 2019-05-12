describe Input do
  after { Input.instance_variable_set("@shared_instance", nil) }

  let(:described_instance) { Input.shared_instance }

  describe ".shared_instance" do
    subject { described_class.shared_instance }

    it "returns the same instance each time" do
      expect(subject)
        .to eq(described_class.shared_instance)
    end

    it "returns an instance" do
      expect(subject).to be_an(Input)
    end
  end

  describe ".touch_count" do
    subject { described_class.touch_count }

    it "calls on the shared_instance" do
      return_value = double

      expect(described_class.shared_instance)
        .to receive(:touch_count)
        .and_return(return_value)

      expect(subject).to eq(return_value)
    end
  end

  describe "#get_touch" do
    let(:touch_index) { 0 }
    subject { described_class.get_touch(touch_index) }

    it "returns nil by default" do
      expect(subject).to eq(nil)
    end

    context "when a touch has began" do
      before do
        described_instance.touch_did_begin("1", Vector[0, 0])
      end

      it "doesn't yet react to that touch" do
        expect(subject).to eq(nil)
      end

      context "when the same touch ends" do
        before do
          described_instance.touch_did_end("1", Vector[1, 1])
        end

        it "still doesn't react" do
          expect(subject).to eq(nil)
        end
      end

      context "when update has been called" do
        before do
          described_instance.update
        end

        it "reacts to the touch" do
          expect(subject).to be_a(Touch)
          expect(subject.id).to eq("1")
          expect(subject.position).to eq(Vector[0, 0])
          expect(subject.original_position).to eq(Vector[0, 0])
          expect(subject.phase).to eq(:began)
        end

        context "when update is called" do
          before do
            described_instance.update
          end

          it "changes phase to stationary" do
            expect(subject.id).to eq("1")
            expect(subject.phase).to eq(:stationary)
          end
        end

        context "when the touch is moved" do
          before do
            described_instance.touch_did_move("1", Vector[1, 2])
          end

          it "doesn't react to the move" do
            expect(subject.id).to eq("1")
            expect(subject.phase).to eq(:began)
            expect(subject.position).to eq(Vector[0, 0])
          end

          context "when update has been called again" do
            before do
              described_instance.update
            end

            it "counts the move" do
              expect(subject.id).to eq("1")
              expect(subject.phase).to eq(:moved)
              expect(subject.position).to eq(Vector[1, 2])
              expect(subject.original_position).to eq(Vector[0, 0])
            end
          end
        end

        context "when the same touch ends" do
          before do
            described_instance.touch_did_end("1", Vector[1, 1])
          end

          it "doesn't react to the end" do
            expect(subject.id).to eq("1")
            expect(subject.phase).to eq(:began)
            expect(subject.position).to eq(Vector[0, 0])
          end

          context "when update has been called again" do
            before do
              described_instance.update
            end

            it "still counts the touch as it has one frame to end" do
              expect(subject.id).to eq("1")
              expect(subject.phase).to eq(:ended)
              expect(subject.position).to eq(Vector[1, 1])
              expect(subject.original_position).to eq(Vector[0, 0])
            end

            context "update for a third time" do
              before do
                described_instance.update
              end

              it "then registers the touch has gone" do
                expect(subject).to eq(nil)
              end
            end
          end
        end
      end
    end
  end

  describe "#touch_count" do
    subject { described_class.touch_count }

    it "equals 0 by default" do
      expect(subject).to eq(0)
    end

    context "when a touch has began" do
      before do
        described_instance.touch_did_begin("1", Vector[0, 0])
      end

      it "doesn't yet react to that touch" do
        expect(subject).to eq(0)
      end

      context "when the same touch ends" do
        before do
          described_instance.touch_did_end("1", Vector[1, 1])
        end

        it "still doesn't react" do
          expect(subject).to eq(0)
        end
      end

      context "when update has been called" do
        before do
          described_instance.update
        end

        it "reacts to the touch" do
          expect(subject).to eq(1)
        end

        context "when the same touch ends" do
          before do
            described_instance.touch_did_end("1", Vector[1, 1])
          end

          it "doesn't react to the end" do
            expect(subject).to eq(1)
          end

          context "when update has been called again" do
            before do
              described_instance.update
            end

            it "still counts the touch as it has one frame to end" do
              expect(subject).to eq(1)
            end

            context "update for a third time" do
              before do
                described_instance.update
              end

              it "then registers the touch has gone" do
                expect(subject).to eq(0)
              end
            end
          end
        end
      end
    end
  end
end
