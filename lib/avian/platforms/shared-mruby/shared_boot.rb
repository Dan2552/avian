#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'fileutils'

def verbose?
  (ENV['VERBOSE'] || "").length > 0
end

def log(str)
  puts(str) if verbose?
end

def error(str)
  STDERR.puts str
  exit 1
end

project_root = ENV['GAME_ROOT']
avian_root = ENV['AVIAN_ROOT']
build_dir = File.join(ENV["HOME"], ".avian", "build")
platform_support = File.join(project_root, "platform_support", "mruby")

FileUtils.mkdir_p(build_dir)

log "--- Compiling mruby ---"
FileUtils.cd(platform_support)
system("bundle exec mundle install") || error("Compiling mruby failed")
mrb_bin = `bundle exec mundle exec which mrbc`.chomp

log "--- Copying resources ---"
# Copy the platform support files into tmp/build
source = File.join(platform_support, ".")
destination = File.join(build_dir)
FileUtils.cp_r(source, destination)

# Copy the resources from the game project into tmp/build/resources/
source = File.join(project_root, "resources", ".")
destination = File.join(build_dir, "game_resources")
FileUtils.cp_r(source, destination)

yaml_files = Dir.glob(File.join(destination, "**", "*.yaml"))
yml_files = Dir.glob(File.join(destination, "**", "*.yml"))
(yaml_files + yml_files).each do |yaml|
  dir = Pathname.new(yaml).dirname
  file = Pathname.new(yaml).basename.to_s.gsub(/\.ya?ml$/, ".json")
  File.write(File.join(dir, file), YAML.load_file(yaml).to_json)
end

log "--- Preparing build files ---"

require 'avian'

avian_files = AVIAN_LOAD_ORDER.map { |glob| Dir.glob(File.join(avian_root, "lib", "avian", glob)) }.flatten
app_files = AVIAN_GAME_LOAD_ORDER.map { |glob| Dir.glob(File.join(project_root, glob)) }.flatten
prefix_files = Dir.glob(File.expand_path(File.join(__dir__, "prefix", "*.rb")))
suffix_files = Dir.glob(File.expand_path(File.join(__dir__, "suffix", "*.rb")))

all_files =
  prefix_files +
  avian_files +
  app_files +
  suffix_files

# Set the current working directory to the build
FileUtils.cd(build_dir)

mrbc = %W(
  #{mrb_bin}
    -g
    -Bapp
    -o./app.c
) + all_files

log "\n--- Compiling ruby game files ---"
system(*mrbc) || error("Compiling failed")
log "Compiling complete."

FileUtils.cd(build_dir)
