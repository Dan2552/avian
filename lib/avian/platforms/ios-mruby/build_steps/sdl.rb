build_dir = File.join(ENV["HOME"], ".avian", "build")

if File.directory?(File.join(build_dir, "ios", "sdl"))
  puts "Using predownloaded sdl"
else
  FileUtils.mkdir_p(File.join(build_dir, "ios"))
  FileUtils.cd(File.join(build_dir, "ios"))
  puts "\n--- Cloning SDL ---"
  system("git clone https://github.com/SDL-mirror/SDL.git sdl") ||
    raise("Failed to clone SDL")
end

if File.file?(File.join(build_dir, "ios", "sdl", "ios-build", "lib", "libSDL2.a"))
  puts "Using prebuilt sdl"
else
  FileUtils.cd(File.join(build_dir, "ios", "sdl"))
  system("build-scripts/iosbuild.sh")
end
