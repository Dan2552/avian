class Time
  class << self
    attr_writer :delta

    def delta
      @delta ||= 0
    end
  end
end
