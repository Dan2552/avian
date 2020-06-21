describe Avian::Text::DialogParser do
  let(:text) { "Listen carefully to what I, the [red]Deku Tree[white], am about to tell thee[slow]..." }
  let(:size) { Size[100, 10] }
  let(:font_name) { "font" }
  let(:font_size) { 16 }
  let(:described_instance) { described_class.new(text, size, font_name, font_size) }

  describe ".new" do
    subject { described_instance }

    context "when the text is valid" do
      it "runs ok" do
        expect { subject }.to_not raise_error
      end
    end

    context "when an instruction isn't closed" do
      let(:text) { "hello[redworld" }
      it "raises an error" do
        expect { subject }.to raise_error("Unending instruction")
      end
    end
  end

  describe "#parts" do
    subject { described_instance.parts }

    context "when everything fits on a single line" do
      before do
        allow(Platform)
          .to receive(:width_of_text)
          .and_return(1)
      end

      it "orders text and instructions together" do
        expect(subject).to eq([
          Avian::Text::DialogParser::DialogText.new("Listen carefully to what I, the "),
          Avian::Text::DialogParser::DialogInstruction.new("red"),
          Avian::Text::DialogParser::DialogText.new("Deku Tree"),
          Avian::Text::DialogParser::DialogInstruction.new("white"),
          Avian::Text::DialogParser::DialogText.new(", am about to tell thee"),
          Avian::Text::DialogParser::DialogInstruction.new("slow"),
          Avian::Text::DialogParser::DialogText.new("...")
        ])
      end

      context "another piece of text" do
        let(:text) { "[red]hello [green]world. This is a test[reset]." }

        it "orders text and instructions together" do
          expect(subject).to eq([
            Avian::Text::DialogParser::DialogInstruction.new("red"),
            Avian::Text::DialogParser::DialogText.new("hello "),
            Avian::Text::DialogParser::DialogInstruction.new("green"),
            Avian::Text::DialogParser::DialogText.new("world. This is a test"),
            Avian::Text::DialogParser::DialogInstruction.new("reset"),
            Avian::Text::DialogParser::DialogText.new(".")
          ])
        end
      end
    end

    context "when a word can't fit, and therefore makes a newline" do
      before do
        allow(Platform).to receive(:width_of_text) do |_, _, text|
          text.split(" ").count
        end
      end

      let(:size) { Size[2, 10] }
      let(:text) { "One two three" }

      it "contains the instruction to make the new line" do
        expect(subject).to eq([
          Avian::Text::DialogParser::DialogText.new("One two"),
          Avian::Text::DialogParser::DialogInstruction.new("newline"),
          Avian::Text::DialogParser::DialogText.new("three")
        ])
      end

      context "with instructions" do
        let(:text) { "[red]One [green]two three four" }

        it "contains newlines and other instructions" do
          expect(subject).to eq([
          Avian::Text::DialogParser::DialogInstruction.new("red"),
          Avian::Text::DialogParser::DialogText.new("One "),
          Avian::Text::DialogParser::DialogInstruction.new("green"),
          Avian::Text::DialogParser::DialogText.new("two"),
          Avian::Text::DialogParser::DialogInstruction.new("newline"),
          Avian::Text::DialogParser::DialogText.new("three four")
        ])
        end
      end
    end
  end
end
