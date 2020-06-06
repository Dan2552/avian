#!/usr/bin/env ruby

require "bundler/inline"
require 'pathname'

gemfile do
  source "https://rubygems.org"
  gem "xcodeproj"
  gem "plist"
  gem "pry"
end

# TODO
PROJECT_NAME = "Midnight"
BUNDLE_IDENTIFIER_PREFIX = "com.example"

def project_path
  @project_path ||= Pathname.new(ENV['XCODE_PROJECT_ROOT'])
end

def project
  @project ||= begin
    filepath = File.join(project_path, "___PROJECTNAME___.xcodeproj")
    raise "Expected xcode project" unless File.directory?(filepath)
    Xcodeproj::Project.open(filepath)
  end
end

def add_include_headers(include_path, group_name)
  sources = project.main_group.find_subpath("Sources")
  raise "Cannot find include directory: #{include_path}" unless include_path.directory?
  sources.new_group(group_name, include_path.relative_path_from(project_path).to_s)
  group = sources.find_subpath(group_name)
  include_files = Dir.glob(File.join(include_path, "*.h"))
  include_files.each do |file|
    group.new_file(file)
  end
end

def find_and_replace(path, old, new)
  text = File.read(path)
  replace = text.gsub(old, new)
  if text != replace
    File.open(path, 'w') { |file| file.puts replace }
  end
end

def find_profile(name)
  filepath = File.join(ENV["HOME"], "Library", "MobileDevice", "Provisioning Profiles", "*")
  Dir.glob(filepath).each do |profile|
    return profile if system("cat \"#{profile}\" | grep \"#{name}\" >/dev/null 2>&1")
  end
  nil
end

#
# Rename the app
#
pbx_proj_path = File.join(project_path, "___PROJECTNAME___.xcodeproj", "project.pbxproj")
find_and_replace(pbx_proj_path, "___PROJECTNAME___", PROJECT_NAME)
find_and_replace(pbx_proj_path, "___PROJECTNAME___", PROJECT_NAME)

#
# Set the reference to the SDL xcodeproj
#
sdl_path = Bundler.root.join("ios", "sdl", "Xcode-iOS", "SDL", "SDL.xcodeproj")
raise "Cannot find SDL" unless sdl_path.directory?
sdl_reference = project.main_group.find_subpath("Sources/SDL.xcodeproj")
sdl_reference.path = sdl_path.relative_path_from(project_path).to_s

sdl_image_path = Bundler.root.join("ios", "sdl_image", "Xcode-iOS", "SDL_image.xcodeproj")
sources = project.main_group.find_subpath("Sources")
sources.new_reference(sdl_image_path)
rb_app = sources.new_reference("app.h")
options = sources.new_reference("options.h")
resources = sources.new_reference("game_resources")

sources.new_reference("LaunchScreen.storyboard")

#
# Add the SDL include headers to the main project
#
add_include_headers(Bundler.root.join("ios", "sdl", "include"), "sdl_include")
add_include_headers(Bundler.root.join("ios", "sdl_image"), "sdl_image")

#
# Add the AVFoundation system framework
#
target = project.targets.first

raise "Target not found" unless target.name == PROJECT_NAME
target.add_system_framework("AVFoundation")
target.add_system_framework("ImageIO")
target.add_system_framework("MobileCoreServices")
target.add_system_framework("Metal")

target.add_file_references([rb_app, options])
target.add_resources([resources])

#
# Add MRuby framework build flags
#
["Debug", "Release"].each do |config|
  target.build_settings(config).merge!(
    "HEADER_SEARCH_PATHS" => ["$(SRCROOT)/MRuby.framework/Headers"],
    "FRAMEWORK_SEARCH_PATHS" => ["$(PROJECT_DIR)"],
    "IPHONEOS_DEPLOYMENT_TARGET" => "10.3",
    "DEVELOPMENT_TEAM" => "3K2TUP9VBZ",
    "ENABLE_BITCODE" => false
  )
end

#
# Add MRuby framework to file references
#
framework_path = "MRuby.framework"
group = project.frameworks_group['iOS'] || project.frameworks_group.new_group('iOS')
ref = group.find_file_by_path(framework_path) || group.new_file(framework_path, :group)
target.frameworks_build_phase.add_file_reference(ref, true)

# Find or create and add a reference for the current product type
# frameworks = project.frameworks_group
# build_phase = target.frameworks_build_phase
# new_product_ref = group.new_product_ref_for_target("SDL2_image", :static_library)
# target.frameworks_build_phase.add_file_reference(new_product_ref, true)

# TODO: delete this once we know for sure SDL_image above worrks
lib_sdl_ref_clone = target.frameworks_build_phase.files_references.find { |ref| ref.path == "libSDL2.a" }.dup
ref = group.new_file("libSDL2_image.a", :group)
ref.explicit_file_type = "archive.ar"
target.frameworks_build_phase.add_file_reference(ref, true)

#
# Save the xcodeproj
#
project.save

plist_path = Bundler.root.join(project_path, "Info.plist")
plist = Plist::parse_xml(plist_path)
plist["CFBundleShortVersionString"] = "1.0"
plist["UILaunchStoryboardName"] = "LaunchScreen"

plist["CFBundleIdentifier"] = "#{BUNDLE_IDENTIFIER_PREFIX}.${PRODUCT_NAME:identifier}"
File.open(plist_path, 'w') { |file| file.write(plist.to_plist) }


