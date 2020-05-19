module ObjectDebugExtension
  def method_missing(meth, *args, &blk)
    raise NoMethodError, "Undefined method '#{meth}' for #{self.class} - #{self.inspect}"
  end
end

Object.class_exec do
  prepend ObjectDebugExtension
end

def _debugger_input(input)
  s = "begin\n"
  r = "\nrescue => exc\nputs exc.class.to_s; puts exc.inspect\nend"

  s + input + r
end

DEBUGGER = '
parts = caller[0].split(":", 3)
file = parts[0]
line_str = parts[1]
line = line_str.to_i
output = File.read(file).split("\n")
puts ""
puts "From: #{file} @ line #{line} :"
puts ""
puts "   : #{output[line - 6]}" rescue nil
puts "   : #{output[line - 5]}" rescue nil
puts "   : #{output[line - 4]}" rescue nil
puts "   : #{output[line - 3]}" rescue nil
puts "   : #{output[line - 2]}" rescue nil
puts "=> : #{output[line - 1]}"
puts "   : #{output[line - 0]}" rescue nil
puts "   : #{output[line + 1]}" rescue nil
puts "   : #{output[line + 2]}" rescue nil
puts "   : #{output[line + 3]}" rescue nil
puts "   : #{output[line + 4]}" rescue nil
puts ""

loop do
  begin
    print "(debugger) > "
    _input = gets
    if _input.nil? || _input.chomp == "continue" || _input.chomp == "exit"
      break
    end
    output = eval(_debugger_input(_input)).inspect
    puts("=> #{output}")
    output
  end
end
'
