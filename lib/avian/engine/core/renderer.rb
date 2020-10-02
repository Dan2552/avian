class Renderer
  def initialize(root)
    @root = root
  end

  def draw_frame
    camera = root.camera

    Platform.set_camera_attributes(
      camera.position,
      camera.scale,
      camera.scale
    )

    Platform.draw_frame
  end

  private

  attr_reader :root
end
