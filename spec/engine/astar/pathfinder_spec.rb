RSpec.describe AStar::Pathfinder do
  let(:graph) { AStar::GraphFactory.two_dimensional_graph(5, 5) }
  let(:described_instance) { described_class.new(graph) }

  describe "#graph" do
    subject { described_instance.graph }

    it "equals the graph the instance was initialized with" do
      expect(subject).to eq(graph)
    end
  end

  describe "#find_path" do
    it "calculates a straight line when possible" do
      #   0 1 2 3 4
      #   ---------
      # 0|o o o o o
      # 1|o o o o o
      # 2|o o o o o
      # 3|o o o o o
      # 4|o o o o o

      start = graph.find("0,2")
      goal = graph.find("4,2")

      expected_path = [
        start,
        graph.find("1,2"),
        graph.find("2,2"),
        graph.find("3,2"),
        goal
      ]
      path = described_instance.find_path(start, goal)
      expect(path).to eq(expected_path)
    end

    it "finds a way through a maze" do
      #   0 1 2 3 4
      #   ---------
      # 0|o x o o o
      # 1|o x o x o
      # 2|o x o x o
      # 3|o x o x o
      # 4|o o o x o

      graph.remove_vertex_named("1,0")
      graph.remove_vertex_named("1,1")
      graph.remove_vertex_named("1,2")
      graph.remove_vertex_named("1,3")

      graph.remove_vertex_named("3,1")
      graph.remove_vertex_named("3,2")
      graph.remove_vertex_named("3,3")
      graph.remove_vertex_named("3,4")

      start = graph.find("0,0")
      goal = graph.find("4,4")
      path = described_instance.find_path(start, goal)

      expect(path.first).to eq(start)
      expect(path.last).to eq(goal)
      expect(path.count).to eq(17)
      expect(path).to include(graph.find("1,4"))
      expect(path).to include(graph.find("2,0"))
      expect(path).to include(graph.find("2,2"))
      expect(path).to include(graph.find("4,0"))
    end

    it "should realise when the goal is inaccessible" do
      #   0 1 2 3 4
      #   ---------
      # 0|o o o o o
      # 1|o o o o o
      # 2|o o o o o
      # 3|o o o x x
      # 4|o o o x o

      graph.remove_vertex_named("3,3")
      graph.remove_vertex_named("3,4")
      graph.remove_vertex_named("4,3")

      start = graph.find("0,0")
      goal = graph.find("4,4")

      path = described_instance.find_path(start, goal)
      expect(path.count).to eq(0)
    end

    it "can calculate the closest path when inaccessible" do
      #   0 1 2 3 4
      #   ---------
      # 0|o o o o o
      # 1|o o o o o
      # 2|o o o o o
      # 3|o o o x x
      # 4|o o o x o

      graph.remove_vertex_named("3,3")
      graph.remove_vertex_named("3,4")
      graph.remove_vertex_named("4,3")

      start = graph.find("0,0")
      goal = graph.find("4,4")

      path = described_instance.find_path(start, goal, true)
      expect(path.count).to_not eq(0)
      expect(path.last).to eq(graph.find("4,2")).or eq(graph.find("2,4"))
    end

    it "should be able to give a closest when blocked" do
      #   0 1 2 3 4
      #   ---------
      # 0|o o o o o
      # 1|o o x o o
      # 2|o o x o o
      # 3|o o x o o
      # 4|o o o o o

      graph.find("2,1").blocked = true
      graph.find("2,2").blocked = true
      graph.find("2,3").blocked = true

      start = graph.find("0,0")
      goal = graph.find("2,2")

      path = described_instance.find_path(start, goal, true)
      expect(path.count).to_not eq(0)

      # was a known bug to return the last element:
      bug = path.last == graph.find("4,4")
      expect(bug).to eq(false)
    end

    context "different sized graph" do
      let(:graph) { AStar::GraphFactory.two_dimensional_graph(3, 3) }

      it "should be able to give a closest when inaccessible 2" do
        graph.find("1,1").blocked = true

        start = graph.find("0,1")
        goal = graph.find("1,1")
        path = described_instance.find_path(start, goal, true)

        expect(path.first).to eq(start)
        expect(path.count).to eq(1)
      end
    end
  end
end
