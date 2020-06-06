build_dir = File.join("/", "tmp", "avian", "build")

if File.directory?(File.join(build_dir, "ios", "sdl"))
  puts "Using predownloaded sdl"
else
  FileUtils.mkdir_p(File.join(build_dir, "ios"))
  FileUtils.cd(File.join(build_dir, "ios"))
  puts "\n--- Cloning SDL ---"
  system("git clone https://github.com/SDL-mirror/SDL.git sdl") ||
    raise("Failed to clone SDL")
end

if File.directory?(File.join(build_dir, "ios", "sdl_image"))
  puts "Using predownloaded sdl_image"
else
  FileUtils.mkdir_p(File.join(build_dir, "ios"))
  FileUtils.cd(File.join(build_dir, "ios"))
  puts "\n--- Cloning SDL_image ---"
  system("git clone https://github.com/SDL-mirror/SDL_image.git sdl_image") ||
    raise("Failed to clone SDL_image")
end

if File.directory?(File.join(build_dir, "ios", "sdl-gpu"))
  puts "Using predownloaded sdl-gpu"
else
  FileUtils.mkdir_p(File.join(build_dir, "ios"))
  FileUtils.cd(File.join(build_dir, "ios"))
  system("git clone https://github.com/grimfang4/sdl-gpu.git sdl-gpu") ||
    raise("Failed to clone sdl-gpu")
end
