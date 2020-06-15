#!/usr/bin/env ruby

build_dir = File.join(ENV["HOME"], ".avian", "build")

if File.directory?(File.join(build_dir, "ios", "sdl_image"))
  puts "Using predownloaded sdl_image"
else
  FileUtils.mkdir_p(File.join(build_dir, "ios"))
  FileUtils.cd(File.join(build_dir, "ios"))
  puts "\n--- Cloning SDL_image ---"
  system("git clone https://github.com/SDL-mirror/SDL_image.git sdl_image") ||
    raise("Failed to clone SDL_image")
end

configuration = "Release"

require 'fileutils'

FileUtils.cd(File.join(build_dir, "ios", "sdl_image", "Xcode-iOS"))


if File.file?(File.join(build_dir, "ios", "sdl_image", "Xcode-iOS", "build", "#{configuration}-fat", "libSDL2_image.a"))
  puts "Using prebuilt sdl_image"
else
  clean_simulator = %W(
    xcodebuild
      -project SDL_image.xcodeproj
      -target libSDL_image-iOS
      -sdk iphonesimulator
      -configuration #{configuration}
      clean
  )

  clean_device = %W(
    xcodebuild
      -project SDL_image.xcodeproj
      -target libSDL_image-iOS
      -sdk iphoneos
      -arch x86_64
      -arch i386
      -configuration #{configuration}
      clean
  )

  build_simulator = %W(
    xcodebuild
      -project SDL_image.xcodeproj
      -target libSDL_image-iOS
      -sdk iphonesimulator
      -configuration #{configuration}
      build
  )

  build_device = %W(
    xcodebuild
      -project SDL_image.xcodeproj
      -target libSDL_image-iOS
      -sdk iphoneos
      -arch arm64
      -arch armv7
      -arch armv7s
      -configuration #{configuration}
      build
  )

  simulator_build = File.join("build", "#{configuration}-iphoneos", "libSDL2_image.a")
  device_build = File.join("build", "#{configuration}-iphonesimulator", "libSDL2_image.a")
  fat_build = File.join("build", "#{configuration}-fat", "libSDL2_image.a")

  lipo = %W(
    lipo
      #{device_build}
      #{simulator_build}
      -create
      -output #{fat_build}
  )

  system(*clean_simulator) || raise("Failed to clean simulator")
  system(*clean_device) || raise("Failed to clean device")
  system(*build_simulator) || raise("Failed to build simulator")
  system(*build_device) || raise("Failed to build device")
  FileUtils.mkdir_p(File.join("build", "#{configuration}-fat"))
  system(*lipo) || raise("Failed creating sdl_image universal library")
end
