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

  vector :renderable_anchor_point, default: Vector[0.0, 1.0]

  attribute :instruction_handler, type: Object

  attr_reader :lines

  attr_reader :visual_text

  def initialize
    self.font_size = font_size
    @lines = 1
  end

  def fully_revealed?
    !@hiding_index || @hiding_index >= visual_text.length
  end

  def reveal_next_character
    return if fully_revealed?
    return unless @hiding_index

    hide_characters_beyond(@hiding_index + 1)
  end

  def hide_all_characters
    hide_characters_beyond(0)
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

  def size=(new_size)
    @size = new_size
    reset_text_box_parts!
  end

  def color=(new_color)
    @color = new_color
    reset_text_box_parts!
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

  def hide_characters_beyond(to_hide_index)
    reset_text_box_parts!
    old_hiding_index = @hiding_index

    return if old_hiding_index == to_hide_index

    @hiding_index = to_hide_index
    current_index = 0
    hiding = false
    text_box_parts.each do |part|
      part.text = "" if hiding
      part.text.each_char.with_index do |char, index_within_part|
        if current_index == old_hiding_index && to_hide_index > old_hiding_index
          if instruction_handler.respond_to?(:will_reveal_character_in_part)
            instruction_handler.will_reveal_character_in_part(index_within_part, part)
          end
        elsif current_index == to_hide_index
          part.text = part.text[0...index_within_part]
          hiding = true
        end
        current_index = current_index + 1
      end
    end
  end

  def reset_text_box_parts!
    return if @skip_reset

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

    instructions = []

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
        instructions << part.text
        case part.text
        when "newline"
          y = y - line_height
          x = 0
          @lines = @lines + 1
        else
          if part.text.start_with?("#")
            color_as_string = "0x#{part.text[1..-1]}"
            current_color = eval(color_as_string)
          else
            if instruction_handler.respond_to?(:handle_instruction)
              instruction_handler.handle_instruction(part.text, for_part)
            end
          end
        end
      end

      child.instructions = instructions.dup
    end

    @skip_reset = true
    self.size = Size[size.width, line_height * lines.to_f]
    @skip_reset = false

    @visual_text = ""
    text_box_parts.each do |part|
      @visual_text = @visual_text + part.text
    end
  end

  def prepare_children(target_count)
    current_count = text_box_parts.count
    return if target_count == current_count

    if target_count > current_count
      additional_count = target_count - current_count
      additional_count.times { text_box_parts << TextBoxPart.new }
    else # target_count < current_count
      to_remove = text_box_parts[target_count..-1]
      to_remove.each { |label| label.destroy }
    end
  end

  def width_of_child(child)
    Platform.width_of_text(child.font_name, child.font_size, child.text)
  end
end
