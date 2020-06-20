module Avian
  module Text
    # Given the following input:
    #
    # "Listen carefully to what I, the [red]Deku Tree[reset], am about to tell
    # thee[slow]..."
    #
    # will return an object with enough information to help render the text
    # with:
    # * highlighting "Deku Tree" as red text
    # * slowing down the characters incoming animation rate on the "..."
    #
    class DialogParser
      class DialogText
        def initialize(text)
          @text = text
        end

        attr_reader :text

        def ==(comparison)
          self.class == comparison.class && text == comparison.text
        end

        def inspect
          "<Text:\"#{text}\">"
        end
      end

      class DialogInstruction
        def initialize(text)
          @text = text
        end

        attr_reader :text

        def ==(comparison)
          self.class == comparison.class && text == comparison.text
        end

        def inspect
          "<Instruction:\"#{text}\">"
        end
      end

      DEFAULT_INSTRUCTION_OPENING_CHAR = "["
      DEFAULT_INSTRUCTION_CLOSING_CHAR = "]"

      def initialize(text, size, font_name, font_size, instruction_opening_char = DEFAULT_INSTRUCTION_OPENING_CHAR, instruction_closing_char = DEFAULT_INSTRUCTION_CLOSING_CHAR)
        @parts = []
        @instructions = []
        @font_name = font_name
        @font_size = font_size
        @size = size

        text.each_char do |char|
          @current_character = char
          case char
          when " "
            handle_end_of_word
          when instruction_opening_char
            handle_opening_of_instruction
          when instruction_closing_char
            handle_closing_of_instruction
          else
            if handling_instruction?
              handle_instruction
            else
              handle_regular
            end
          end
        end

        raise "Unending instruction" if handling_instruction?

        handle_end
      end

      attr_reader :parts

      private

      attr_reader :current_character

      def handling_instruction?
        @handling_instruction
      end

      def handle_regular
        @current_characters ||= ""
        @current_characters << current_character
      end

      def handle_end_of_word
        @current_characters ||= ""
        @current_characters += " "

        handle_word_wont_fit if word_wont_fit?
      end

      def handle_opening_of_instruction
        if !@current_characters.nil? && @current_characters.length > 0
          parts << DialogText.new(@current_characters)
        end
        @current_characters = ""
        @handling_instruction = true
      end

      def handle_instruction
        @current_instruction ||= ""
        @current_instruction << current_character
      end

      def handle_closing_of_instruction
        parts << DialogInstruction.new(@current_instruction)
        @current_instruction = ""
        @handling_instruction = false
      end

      def handle_end
        handle_word_wont_fit if word_wont_fit?

        parts << DialogText.new(@current_characters)
      end

      def handle_word_wont_fit
        words = @current_characters.split(" ")
        parts << DialogText.new(words[0..-2].join(" "))
        parts << DialogInstruction.new("newline")
        @current_characters = words.last
      end

      def word_wont_fit?
        potential_words = @current_characters
        Platform.width_of_text(@font_name, @font_size, potential_words) > @size.width
      end
    end
  end
end
