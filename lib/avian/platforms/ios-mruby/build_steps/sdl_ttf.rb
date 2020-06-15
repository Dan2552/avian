build_dir = File.join(ENV["HOME"], ".avian", "build")
script_dir = __dir__

if File.directory?(File.join(build_dir, "ios", "sdl_ttf"))
  puts "Using predownloaded sdl_ttf"
else
  FileUtils.mkdir_p(File.join(build_dir, "ios"))
  FileUtils.cd(File.join(build_dir, "ios"))
  puts "\n--- Cloning SDL_ttf ---"
  system("git clone https://github.com/SDL-mirror/SDL_ttf.git sdl_ttf") ||
    raise("Failed to clone SDL_ttf")
end

configuration = "Release"

if File.file?(File.join(build_dir, "ios", "sdl_ttf", "Xcode", "build", "#{configuration}-fat", "libSDL2_ttf.a"))
  puts "Using prebuilt sdl_ttf"
else
  FileUtils.cd(File.join(build_dir, "ios", "sdl_ttf"))
  system("git reset --hard 2a6f04c") || raise("Failed to reset to known commit for sdl_ttf")
  patch = File.join(script_dir, "_sdl_ttf", "0001-Fix-iOS-simulator-build.patch")
  system("git apply #{patch}") || raise("Failed to patch sdl_ttf")

  FileUtils.cd(File.join(build_dir, "ios", "sdl_ttf", "Xcode"))

  clean_simulator = <<-STR
    xcodebuild \
      -project SDL_ttf.xcodeproj \
      -target "Static Library-iOS" \
      -sdk iphonesimulator \
      -configuration #{configuration} \
      clean
  STR

  clean_device = <<-STR
    xcodebuild \
      -project SDL_ttf.xcodeproj \
      -target "Static Library-iOS" \
      -sdk iphoneos \
      -configuration #{configuration} \
      clean
  STR

  build_simulator = <<-STR
    xcodebuild \
      -project SDL_ttf.xcodeproj \
      -target "Static Library-iOS" \
      -sdk iphonesimulator \
      -arch x86_64 \
      -arch i386 \
      -configuration #{configuration} \
      build
  STR

  build_device = <<-STR
    xcodebuild \
      -project SDL_ttf.xcodeproj \
      -target "Static Library-iOS" \
      -sdk iphoneos \
      -arch arm64 \
      -arch armv7 \
      -arch armv7s \
      -configuration #{configuration} \
      build
  STR

  simulator_build = File.join("build", "#{configuration}-iphoneos", "libSDL2_ttf.a")
  device_build = File.join("build", "#{configuration}-iphonesimulator", "libSDL2_ttf.a")
  fat_build = File.join("build", "#{configuration}-fat", "libSDL2_ttf.a")

  lipo = %W(
    lipo
      #{device_build}
      #{simulator_build}
      -create
      -output #{fat_build}
  )
  system(clean_simulator) || raise("Failed to clean simulator")
  system(clean_device) || raise("Failed to clean device")
  system(build_simulator) || raise("Failed to build simulator")
  system(build_device) || raise("Failed to build device")

  FileUtils.mkdir_p(File.join("build", "#{configuration}-fat"))
  system(*lipo) || raise("Failed creating sdl_ttf universal library")
end
