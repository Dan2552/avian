#!/usr/bin/env ruby

require "bundler/inline"
require 'pathname'

project_path = Pathname.new(ENV['XCODE_PROJECT_ROOT'])

gemfile do
  source "https://rubygems.org"
  gem "xcodeproj"
  gem "plist"
  gem "pry"
end

filepath = File.join(project_path, "___PROJECTNAME___.xcodeproj")
raise "Expected xcode project" unless File.directory?(filepath)

project = Xcodeproj::Project.open(filepath)

#
# Set the reference to the SDL xcodeproj
#
sdl_reference = project.main_group.find_subpath("Sources/SDL.xcodeproj")
sdl_path = Bundler.root.join("ios", "sdl", "Xcode-iOS", "SDL", "SDL.xcodeproj")
raise "Cannot find SDL" unless sdl_path.directory?
sdl_reference.path = sdl_path.relative_path_from(project_path).to_s

#
# Add the include headers to the main project
#
sources = project.main_group.find_subpath("Sources")
include_path = Bundler.root.join("ios", "sdl", "include")
raise "Cannot find SDL include directory" unless include_path.directory?
sources.new_group("sdl_include", include_path.relative_path_from(project_path).to_s)
sdl_include = sources.find_subpath("sdl_include")
include_files = Dir.glob(File.join(include_path, "*"))
include_files.each do |file|
  sdl_include.new_file(file)
end

#
# Add the AVFoundation system framework
#
target = project.targets.first
raise "Target not found" unless target.name == "___PROJECTNAME___"
target.add_system_framework("AVFoundation")

#
# Add MRuby framework build flags
#
["Debug", "Release"].each do |config|
  target.build_settings(config).merge!(
    "HEADER_SEARCH_PATHS" => ["$(SRCROOT)/MRuby.framework/Headers"],
    "FRAMEWORK_SEARCH_PATHS" => ["$(PROJECT_DIR)"]
  )
end

#
# Add MRuby framework to file references
#
framework_path = "MRuby.framework"
group = project.frameworks_group['iOS'] || project.frameworks_group.new_group('iOS')
ref = group.find_file_by_path(framework_path) || group.new_file(framework_path, :group)
target.frameworks_build_phase.add_file_reference(ref, true)

#
# Save the xcodeproj
#
project.save

#
# Set CFBundleShortVersionString on the Info.plist as for some reason it's
# missing in the template
#
plist_path = Bundler.root.join(project_path, "Info.plist")
plist = Plist::parse_xml(plist_path)
plist["CFBundleShortVersionString"] = "1.0"
File.open(plist_path, 'w') { |file| file.write(plist.to_plist) }
