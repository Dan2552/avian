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
