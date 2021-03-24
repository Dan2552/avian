require "fileutils"

class RollbackTransaction < StandardError; end

def find_and_replace(path, old, new)
  text = File.read(path)
  replace = text.gsub(old, new)
  if text != replace
    File.open(path, 'w') { |file| file.puts replace }
  end
end

def launch_taking_a_screenshot(after:)
  previous = Dir.pwd

  screenshot_code = """
    every(#{after.to_i.to_s}.seconds) do
      bridge = Avian::CBridge.new
      bridge.create_screenshot('/tmp/avian.bmp')
      raise ExitError
    end
  """

  File.transaction(Bundler.root) do |dir|
    find_and_replace(
      File.join(dir, "spec_fixtures", "TestGame", "app", "game_objects", "example.rb"),
      "{{ screenshot_code_here }}",
      screenshot_code
    )

    Bundler.with_clean_env do
      FileUtils.cd(File.join(dir, "spec_fixtures", "TestGame"))
      system("bundle exec avian start") || raise("Failed to launch avian")
      system("cd /tmp && convert avian.bmp avian.png") || raise("Failed to launch convert")
    end

    raise RollbackTransaction
  end
rescue RollbackTransaction
ensure
  FileUtils.cd(previous)
end

class FrameCount
  def initialize(count)
    @count = count
  end

  attr_reader :count

  def to_i
    count
  end
end

module FrameHelpers
  def frames
    FrameCount.new(self)
  end

  def frame
    frames
  end
end

class Integer
  include FrameHelpers
end

def expect_looks_same(after:)
  launch_taking_a_screenshot(after: after)

  # TODO
  # filename = rspec_stuff

  # if File.file?(filename)
  #   system("compare . .. .... .")
  #   code = $?.exitstatus

  #   case code
  #   when 0
  #     puts "s'all good"
  #   when 1
  #     puts "good enough"
  #   when 2
  #     raise "oh noes"
  #   end
  # else
  #   puts "New picture. Look ok?"
  #   response = gets.chomp
  #   if response == "y"
  #     save
  #   else
  #     raise "blah"
  #   end
  # end
end

