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
_parts = caller[0].split(":", 3)
_file = _parts[0]
_line_str = _parts[1]
_line = _line_str.to_i
output = File.read(_file).split("\n")
puts ""
puts "From: #{_file} @ line #{_line} :"
puts ""
puts "   : #{output[_line - 6]}" rescue nil
puts "   : #{output[_line - 5]}" rescue nil
puts "   : #{output[_line - 4]}" rescue nil
puts "   : #{output[_line - 3]}" rescue nil
puts "   : #{output[_line - 2]}" rescue nil
puts "=> : #{output[_line - 1]}"
puts "   : #{output[_line - 0]}" rescue nil
puts "   : #{output[_line + 1]}" rescue nil
puts "   : #{output[_line + 2]}" rescue nil
puts "   : #{output[_line + 3]}" rescue nil
puts "   : #{output[_line + 4]}" rescue nil
puts ""

loop do
  begin
    print "(debugger) > "
    _input = gets
    if _input.nil? || _input.chomp == "continue" || _input.chomp == "exit"
      break
    end

    if _input.chomp == "exit!" || _input.chomp == "!!!"
      raise ExitError
    end

    output = eval(_debugger_input(_input)).inspect
    puts("=> #{output}")
    output
  rescue Exception => exc
    raise exc if exc.is_a?(ExitError)
    puts exc.class.to_s
    puts exc.inspect
  end
end
'
