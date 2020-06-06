build_dir = File.join("/", "tmp", "avian", "build")

if File.file?(File.join(build_dir, "ios", "sdl", "ios-build", "lib", "libSDL2.a"))
  puts "Using prebuilt sdl"
else
  FileUtils.cd(File.join(build_dir, "ios", "sdl"))
  system("build-scripts/iosbuild.sh")
end
