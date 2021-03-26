require "fileutils"

class RollbackTransaction < StandardError; end

def find_and_replace(path, old, new)
  text = File.read(path)
  replace = text.gsub(old, new)
  if text != replace
    File.open(path, 'w') { |file| file.puts replace }
  end
end

# - parameter dir: temp directory
# - parameter project: e.g. "shape-motion"
# - parameter after: Duration or FrameCount
#
def craft_project(dir, project, after, filepath)
  project_dir = File.join(dir, "spec_fixtures", "_project")
  to_import = File.join(dir, "spec_fixtures", project)
  screenshotter = File.join(project_dir, "app", "game_objects", "screenshotter.rb")

  if after.is_a?(Duration)
    find_and_replace(screenshotter, "SCREENSHOT_TYPE = :frames", "SCREENSHOT_TYPE = :duration")
  end

  find_and_replace(screenshotter, "SCREENSHOT_AFTER = 1", "SCREENSHOT_AFTER = #{after.to_i}")

  FileTransaction.relative_files_in(to_import).each do |file|
    FileUtils.cp(File.join(to_import, file), File.join(project_dir, file))
  end

  FileUtils.cd(File.join(project_dir))
end

def truthy?(input)
  [
    "y",
    "yes",
    "ok",
    "okay",
    "sure",
    "true",
    "affirmative",
    "1",
    "fine",
    "whatever",
    "mkay",
    "confirm",
    "confirmed",
    "true",
    "alright"
  ].include?(input.downcase.chomp.strip)
end

def launch_taking_a_screenshot(project, after, filepath, threshold)
  return unless `which compare`.chomp.length > 1

  previous = Dir.pwd
  File.transaction(Bundler.root) do |dir|
    craft_project(dir, project, after, filepath)

    Bundler.with_clean_env do
      FileUtils.rm("/tmp/avian.bmp") rescue nil
      FileUtils.rm("/tmp/avian.png") rescue nil
      system("bundle exec avian start") || raise("Failed to launch avian")
      File.file?("/tmp/avian.bmp") || raise("No screenshot found")
      system("cd /tmp && convert avian.bmp avian.png") || raise("Failed to launch convert")

      filepath = filepath.to_s + ".png"
      if File.file?(filepath)
        a = filepath
        b = "/tmp/avian.png"
        system("compare -verbose -metric PAE -subimage-search -dissimilarity-threshold #{threshold} #{a} #{b} /dev/null")
        code = $?.exitstatus
        case code
        when 0
          puts "s'all good 🥇"
        when 1
          puts "good enough 🥈"
        when 2
          system("open #{filepath}")
          system("open /tmp/avian.png")

          puts "Image isn't the same. Type \"yes\" to override"
          print "> "

          if truthy?(STDIN.gets)
            FileUtils.cp("/tmp/avian.png", filepath)
          else
            raise "Not ok"
          end
        end
      else
        puts "New picture. Look ok?"
        system("open /tmp/avian.png")
        print "> "

        if truthy?(STDIN.gets)
          FileUtils.cp("/tmp/avian.png", filepath)
        else
          raise "Not ok"
        end
      end
    end

    FileUtils.cd(previous)
    raise RollbackTransaction
  end
rescue RollbackTransaction
rescue Exception => e
  puts "!!!!"
  puts e
  puts "!!!!"
  raise e
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

  def inspect
    "#{count} frames"
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

class Example
  def self.current
    @current
  end

  def self.current=(set)
    @current = set
  end
end

require 'rspec/expectations'
RSpec.configure do |config|
  config.before(:each) do |ex|
    example = ex.respond_to?(:metadata) ? ex : ex.example
    Example.current = example
  end
end

RSpec::Matchers.define :look_correct_after do |time|
  match do |actual|
    example_description = Example.current.metadata[:full_description]
    filepath = Bundler.root.join("spec_fixtures", "_images", example_description.gsub(" ", "-"))
    threshold = Example.current.metadata[:threshold] || 0

    begin
      launch_taking_a_screenshot(actual, time, filepath, threshold)
      true
    rescue Exception
      false
    end
  end
end
