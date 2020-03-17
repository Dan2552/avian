class NilClass
  # On irb, this returns nil by default. On Rubymotion, it raises by default.
  #
  def clone
    nil
  end
end

unless defined?(SecureRandom)
  module SecureRandom
    def self.uuid
      uuid = CFUUIDCreate(nil)
      CFUUIDCreateString(nil, uuid)
    end
  end
end

class File
  def self.read(path)
    if path.start_with?("resources/")
      path.sub!("resources", NSBundle.mainBundle.resourcePath)
    end

    super(path)
  end
end

unless defined?(JSON)
  module JSON
    class ParserError < StandardError; end
    def self.parse(json_string)
      puts json_string
      opts = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
      data = json_string.dataUsingEncoding(NSUTF8StringEncoding)
      error = Pointer.new(:id)
      json_hash = NSJSONSerialization.JSONObjectWithData(
        data,
        options:opts,
        error:error
      )

      raise ParserError, error[0].description if error[0]

      json_hash
    end
  end
end
