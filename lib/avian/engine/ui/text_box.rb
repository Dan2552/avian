class TextBox < GameObject::Base
  # A textbox can contain one or more parts of text.
  #
  # For example:
  # * For newlines
  # * changes in font styles (color, boldness).
  #
  # The UITextBox class will handle this relationship entirely, and should not
  # be called outside of this class.
  #
  has_many :text_box_parts

  # The text the textbox as a whole contains.
  #
  string :text, default: ""

  number :line_height, default: -1
  # TODO: none of the font size works at the momennt as it's harcoded in C
  # when not hardcoded, double check #size returns the correct height. Note
  # everything is renderered depending on camera zoom
  number :font_size, default: 32
  string :font_name, default: "TODO"

  vector :size, default: Size[200, 0]

  number :color, default: 0xffffff

  attr_reader :lines

  def initialize
    self.font_size = font_size
    @lines = 1
  end

  # See `#text`.
  #
  def text=(text)
    @text = text
    reset_text_box_parts!
  end

  def font_size=(value)
    self.size = Size[size.width, line_height * lines.to_f]
    @font_size = value
  end

  def line_height
    line_height = @line_height || -1
    if line_height == -1
      twenty_percent = (font_size * 0.20)
      (font_size + twenty_percent).round
    else
      line_height
    end
  end

  private

  def reset_text_box_parts!
    @lines = 1

    dialog_parser = Avian::Text::DialogParser.new(
      text,
      size,
      "TODO",
      font_size
    )

    target_count = dialog_parser.parts.select { |part| part.text? }.count
    prepare_children(target_count)

    current_index = 0
    current_color = color
    previous = nil
    x = 0
    y = 0

    dialog_parser.parts.each do |part|
      child = text_box_parts[current_index]

      if part.text?
        child.color = current_color
        child.text = part.text
        child.size = Size[width_of_child(child), line_height]
        child.relative_position = Vector[x, y]
        child.font_size = font_size

        x = x + child.size.width
        previous = child

        current_index = current_index + 1
      elsif part.instruction?
        case part.text
        when "newline"
          y = y - line_height
          x = 0
          @lines = @lines + 1
        end
      end
    end

    self.size = Size[size.width, line_height * lines.to_f]
  end

  def prepare_children(target_count)
    current_count = text_box_parts.count
    return if target_count == current_count

    if target_count > current_count
      additional_count = target_count - current_count
      additional_count.times { text_box_parts << TextBoxPart.new }
    else # target_count < current_count
      to_remove = text_box_parts[target_count..-1]
      to_remove.each { |label| text_box_parts.delete(label) }
    end
  end

  def width_of_child(child)
    Platform.width_of_text(child.font_name, child.font_size, child.text)
  end
end
