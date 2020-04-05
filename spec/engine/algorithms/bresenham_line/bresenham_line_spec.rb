describe BresenhamLine do
  describe ".iterate_line" do
    let(:p1) { Vector[0, 0] }
    let(:p2) { Vector[1, 5] }

    it "exposes each 'pixel' that the line covers" do
      collection = []
      described_class.iterate_line(p1, p2) do |x, y|
        collection << [x, y]
      end

      #   | 0 1 2 3 4 5
      # ---------------
      # 0 | O X X X X X
      # 1 | O X X X X X
      # 2 | O X X X X X
      # 3 | X O X X X X
      # 4 | X O X X X X
      # 5 | X O X X X X
      expect(collection).to eq(
        [
          [0, 0],
          [0, 1],
          [0, 2],
          [1, 3],
          [1, 4],
          [1, 5]
        ])
    end
  end
end
