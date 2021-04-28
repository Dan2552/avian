build_dir = File.join(ENV["HOME"], ".avian", "build")
sdl_install = File.join(build_dir, "desktop", "install")

unless File.directory?(File.join(build_dir, "desktop", "sdl"))
  FileUtils.cd(File.join(build_dir, "desktop"))
  log "\n--- Cloning SDL ---"
  system("git clone https://github.com/libsdl-org/SDL sdl") ||
    error("Failed to clone SDL")

  log "\n--- Compiling SDL ---"
  FileUtils.cd(File.join(build_dir, "desktop", "sdl"))
  system("./configure --prefix=#{sdl_install} && make -j4 && make install") || begin
    FileUtils.remove_dir(File.join(build_dir, "desktop", "sdl"))
    error("Failed to compile SDL")
  end
end
