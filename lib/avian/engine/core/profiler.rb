class Profiler
  def self.shared_instance
    @shared_instance ||= new
  end

  def start_of(name)
    profiles[name] = (Time.now.to_f * 1000).to_i
  end

  def end_of(name)
    totals[name] ||= 0
    totals[name] += (Time.now.to_f * 1000).to_i - profiles[name]
    times[name] ||= 0
    times[name] += 1
    profiles[name] = nil
  end

  # Prints totals, and resets for the next frame
  #
  def flush
    puts "Totals: #{totals}"
    puts "Times: #{times}"
    @profiles = nil
    @totals = nil
    @times = nil
  end

  private

  def profiles
    @profiles ||= {}
  end

  def totals
    @totals ||= {}
  end

  def times
    @times ||= {}
  end
end
