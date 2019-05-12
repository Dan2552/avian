require 'ostruct'

describe Math::Direction do
  describe "#positional_difference" do
    subject { described_class.positional_difference(origin, comparison) }

    [
      # Up-right
      [OpenStruct.new(x: 0, y: 0), OpenStruct.new(x: 2, y: 3), 0.982793723247329],

      # Up-left
      [OpenStruct.new(x: 0, y: 0), OpenStruct.new(x: -2, y: 3), 2.158798930342464],

      # Down-left
      [OpenStruct.new(x: 0, y: 0), OpenStruct.new(x: -2, y: -3), -2.158798930342464],

      # Down-right
      [OpenStruct.new(x: 0, y: 0), OpenStruct.new(x: 2, y: -3), -0.982793723247329],

      # Up-right not at (0, 0)
      [OpenStruct.new(x: 1, y: 1), OpenStruct.new(x: 3, y: 4), 0.982793723247329],
    ].each do |args|
      context "given the origin is at (#{args[0].x}, #{args[0].y})" do
        context "and the comparison is set at (#{args[1].x}, #{args[1].y})" do
          let(:origin) { args[0] }
          let(:comparison) { args[1] }
          let(:expected_result) { args[2] }

          it "returns the radian #{args[2]}" do
            expect(subject).to eq(expected_result)
          end
        end
      end
    end
  end

  describe "#direction_to_rotate_multiplier" do
    let(:origin_rotation) { Math::Direction::UP }
    let(:origin) { double(x: 0, y: 0, current_rotation: origin_rotation) }
    let(:comparison) { double(x: 0, y: 0) }

    subject { described_class.direction_to_rotate_multiplier(origin, comparison) }

    context "when origin is facing upwards" do
      let(:origin_rotation) { Math::Direction::UP }

      context "comparison is right" do
        let(:comparison) { double(x: 1, y: 0) }

        it "returns 1" do
          expect(subject).to eq(1)
        end
      end

      context "comparison is down" do
        let(:comparison) { double(x: 0, y: -1) }

        it "returns either 1 or -1" do
          expect(subject == 1 || subject == -1).to eq(true)
        end
      end

      context "comparison is left" do
        let(:comparison) { double(x: -1, y: 0) }

        it "returns -1" do
          expect(subject).to eq(-1)
        end
      end

      context "comparison is up" do
        let(:comparison) { double(x: 0, y: 1) }

        it "returns 0" do
          expect(subject).to eq(0)
        end
      end
    end

    context "when origin is facing right" do
      let(:origin_rotation) { Math::Direction::RIGHT }

      context "comparison is right" do
        let(:comparison) { double(x: 1, y: 0) }

        it "returns 0" do
          expect(subject).to eq(0)
        end
      end

      context "comparison is down" do
        let(:comparison) { double(x: 0, y: -1) }

        it "returns 1" do
          expect(subject).to eq(1)
        end
      end

      context "comparison is left" do
        let(:comparison) { double(x: -1, y: 0) }

        it "returns either 1 or -1" do
          expect(subject == 1 || subject == -1).to eq(true)
        end
      end

      context "comparison is up" do
        let(:comparison) { double(x: 0, y: 1) }

        it "returns -1" do
          expect(subject).to eq(-1)
        end
      end
    end

    context "when origin is facing down" do
      let(:origin_rotation) { Math::Direction::DOWN }

      context "comparison is right" do
        let(:comparison) { double(x: 1, y: 0) }

        it "returns -1" do
          expect(subject).to eq(-1)
        end
      end

      context "comparison is down" do
        let(:comparison) { double(x: 0, y: -1) }

        it "returns 0" do
          expect(subject).to eq(0)
        end
      end

      context "comparison is left" do
        let(:comparison) { double(x: -1, y: 0) }

        it "returns 1" do
          expect(subject).to eq(1)
        end
      end

      context "comparison is up" do
        let(:comparison) { double(x: 0, y: 1) }

        it "returns either 1 or -1" do
          expect(subject == 1 || subject == -1).to eq(true)
        end
      end
    end

    context "when origin is facing left" do
      let(:origin_rotation) { Math::Direction::LEFT }

      context "comparison is right" do
        let(:comparison) { double(x: 1, y: 0) }

        it "returns either 1 or -1" do
          expect(subject == 1 || subject == -1).to eq(true)
        end
      end

      context "comparison is down" do
        let(:comparison) { double(x: 0, y: -1) }

        it "returns -1" do
          expect(subject).to eq(-1)
        end
      end

      context "comparison is left" do
        let(:comparison) { double(x: -1, y: 0) }

        it "returns 0" do
          expect(subject).to eq(0)
        end
      end

      context "comparison is up" do
        let(:comparison) { double(x: 0, y: 1) }

        it "returns 1" do
          expect(subject).to eq(1)
        end
      end
    end
  end

  describe "#rotation_difference" do
    let(:origin_rotation) { Math::Direction::UP }
    let(:origin) { double(x: 0, y: 0, current_rotation: origin_rotation) }
    let(:comparison) { double(x: 0, y: 0) }

    subject { described_class.rotation_difference(origin, comparison) }

    context "when origin is facing upwards" do
      let(:origin_rotation) { Math::Direction::UP }

      context "comparison is right" do
        let(:comparison) { double(x: 1, y: 0) }

        it "returns the radian equivalent of 90 degrees" do
          expect(subject).to eq(1.5707963267948966)
        end
      end

      context "comparison is down" do
        let(:comparison) { double(x: 0, y: -1) }

        it "returns the radian equivalent of 180 degrees" do
          expect(subject == 3.141592653589793 || subject == -3.141592653589793).to eq(true)
        end
      end

      context "comparison is left" do
        let(:comparison) { double(x: -1, y: 0) }

        it "returns the radian equivalent of -90 degrees" do
          expect(subject).to eq(-1.5707963267948966)
        end
      end

      context "comparison is up" do
        let(:comparison) { double(x: 0, y: 1) }

        it "returns the radian equivalent of 0 degrees" do
          expect(subject).to eq(0)
        end
      end
    end

    context "when origin is facing right" do
      let(:origin_rotation) { Math::Direction::RIGHT }

      context "comparison is right" do
        let(:comparison) { double(x: 1, y: 0) }

        it "returns the radian equivalent of 0 degrees" do
          expect(subject).to eq(0)
        end
      end

      context "comparison is down" do
        let(:comparison) { double(x: 0, y: -1) }

        it "returns the radian equivalent of 90 degrees" do
          expect(subject).to eq(1.5707963267948966)
        end
      end

      context "comparison is left" do
        let(:comparison) { double(x: -1, y: 0) }

        it "returns the radian equivalent of 180 degrees" do
          expect(subject == 3.141592653589793 || subject == -3.141592653589793).to eq(true)
        end
      end

      context "comparison is up" do
        let(:comparison) { double(x: 0, y: 1) }

        it "returns the radian equivalent of -90 degrees" do
          expect(subject).to eq(-1.5707963267948966)
        end
      end
    end

    context "when origin is facing down" do
      let(:origin_rotation) { Math::Direction::DOWN }

      context "comparison is right" do
        let(:comparison) { double(x: 1, y: 0) }

        it "returns the radian equivalent of -90 degrees" do
          expect(subject).to eq(-1.5707963267948966)
        end
      end

      context "comparison is down" do
        let(:comparison) { double(x: 0, y: -1) }

        it "returns the radian equivalent of 0 degrees" do
          expect(subject).to eq(0)
        end
      end

      context "comparison is left" do
        let(:comparison) { double(x: -1, y: 0) }

        it "returns the radian equivalent of 90 degrees" do
          expect(subject).to eq(1.5707963267948966)
        end
      end

      context "comparison is up" do
        let(:comparison) { double(x: 0, y: 1) }

        it "returns the radian equivalent of 180 degrees" do
          expect(subject == 3.141592653589793 || subject == -3.141592653589793).to eq(true)
        end
      end
    end

    context "when origin is facing left" do
      let(:origin_rotation) { Math::Direction::LEFT }

      context "comparison is right" do
        let(:comparison) { double(x: 1, y: 0) }

        it "returns the radian equivalent of 180 degrees" do
          expect(subject == 3.141592653589793 || subject == -3.141592653589793).to eq(true)
        end
      end

      context "comparison is down" do
        let(:comparison) { double(x: 0, y: -1) }

        it "returns the radian equivalent of -90 degrees" do
          expect(subject).to eq(-1.5707963267948966)
        end
      end

      context "comparison is left" do
        let(:comparison) { double(x: -1, y: 0) }

        it "returns the radian equivalent of 0 degrees" do
          expect(subject).to eq(0)
        end
      end

      context "comparison is up" do
        let(:comparison) { double(x: 0, y: 1) }

        it "returns the radian equivalent of 90 degrees" do
          expect(subject).to eq(1.5707963267948966)
        end
      end
    end
  end
end
