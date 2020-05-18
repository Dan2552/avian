#!/usr/bin/env ruby

project_root = ENV['GAME_ROOT']
avian_root = ENV['AVIAN_ROOT']
build_dir = File.join("/", "tmp", "avian", "build")
platform_support = File.join(project_root, "platform_support", "mruby")

FileUtils.mkdir_p(build_dir)

puts "--- Compiling mruby ---"
FileUtils.cd(platform_support)
system("bundle exec mundle install") || raise("Compiling failed")

# Copy the platform support files into tmp/build
source = File.join(platform_support, ".")
destination = File.join(build_dir)
FileUtils.cp_r(source, destination)

# Copy the resources from the game project into tmp/build/resources/
source = File.join(project_root, "resources", ".")
destination = File.join(build_dir, "resources")
FileUtils.cp_r(source, destination)

require 'avian'

app_load_order = [
  'lib/**/*.rb',
  'app/values/**/*.rb',
  'app/**/concerns/*.rb',
  'app/**/*.rb',
  'config/**/*.rb'
]

avian_files = AVIAN_LOAD_ORDER.map { |glob| Dir.glob(File.join(avian_root, "lib", "avian", glob)) }.flatten
app_files = app_load_order.map { |glob| Dir.glob(File.join(project_root, glob)) }.flatten
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
  mrbc
    -g
    -Bapp
    -o./app.c
) + all_files

puts "\n--- Compiling ruby game files ---"
system(*mrbc) || raise("Compiling failed")
puts "Compiling complete."

FileUtils.cd(build_dir)
