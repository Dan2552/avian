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
