build_dir = File.join("/", "tmp", "avian", "build")
configuration = "Release"
fat_build = File.join(build_dir, "ios", "sdl-gpu", "libSDL2_gpu.a")

require 'fileutils'

FileUtils.cd(File.join(build_dir, "ios", "sdl-gpu"))

if File.directory?(File.join(build_dir, "ios", "sdl-gpu", "SDL_gpu.xcodeproj/"))
  puts "Using pregenerated sdl-gpu"
else
  cmake = %W(
    cmake
      -DCMAKE_TOOLCHAIN_FILE=#{File.join(build_dir, "ios", "sdl-gpu", "scripts", "ios-cmake", "toolchain", "iOS.cmake")}
      -DCMAKE_IOS_SDK_ROOT=#{`xcrun --sdk iphoneos --show-sdk-path`.chomp}
      -DSDL2_LIBRARY=#{File.join(build_dir, "ios", "sdl", "ios-build", "lib", "libSDL2.a")}
      -DSDL2_INCLUDE_DIR=#{File.join(build_dir, "ios", "sdl", "include")}
      .
      -G Xcode
  )

  system(*cmake) ||
    raise("Failed to generate sdl2_gpu")
end

if File.file?(fat_build)
  puts "Using prebuilt sdl_gpu"
else
  clean_simulator = %W(
    xcodebuild
      -project SDL_gpu.xcodeproj
      -target SDL_gpu
      -sdk iphonesimulator
      -configuration #{configuration}
      clean
  )

  clean_device = %W(
    xcodebuild
      -project SDL_gpu.xcodeproj
      -target SDL_gpu
      -sdk iphoneos
      -arch x86_64
      -arch i386
      -configuration #{configuration}
      clean
  )

  build_simulator = %W(
    xcodebuild
      -project SDL_gpu.xcodeproj
      -target SDL_gpu
      -sdk iphonesimulator
      -configuration #{configuration}
      build
  )

  build_device = %W(
    xcodebuild
      -project SDL_gpu.xcodeproj
      -target SDL_gpu
      -sdk iphoneos
      -arch arm64
      -arch armv7
      -arch armv7s
      -configuration #{configuration}
      build
  )

  simulator_build = File.join("SDL_gpu.build", "#{configuration}-iphoneos", "libSDL2_gpu.a")
  device_build = File.join("SDL_gpu.build", "#{configuration}-iphonesimulator", "libSDL2_gpu.a")

  system(*clean_simulator) || raise("Failed to clean simulator")
  system(*clean_device) || raise("Failed to clean device")
  system(*build_simulator) || raise("Failed to build simulator")

  built_file = File.join(build_dir, "ios", "sdl-gpu", "SDL_gpu", "lib", "Release", "libSDL2_gpu.a")
  simulator_build = File.join(build_dir, "ios", "sdl-gpu", "simulator-libSDL2_gpu.a")
  FileUtils.mv(built_file, simulator_build)

  system(*build_device) || raise("Failed to build device")

  device_build = File.join(build_dir, "ios", "sdl-gpu", "device-libSDL2_gpu.a")
  FileUtils.mv(built_file, device_build)

  lipo = %W(
    lipo
      #{device_build}
      #{simulator_build}
      -create
      -output #{fat_build}
  )

  system(*lipo) || raise("Failed creating sdl_gpu universal library")
end
