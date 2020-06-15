build_dir = File.join(ENV["HOME"], ".avian", "build")
project_root = ENV['GAME_ROOT']
platform_support = File.join(project_root, "platform_support", "mruby")
mruby_build = File.join(build_dir, "ios", "mruby")

FileUtils.mkdir_p(File.join(mruby_build, "include"))
FileUtils.cd(mruby_build)
FileUtils.cp_r(File.join(platform_support, "."), mruby_build)

mruby_path = `bundle exec mundle path`.chomp

ios_lib = File.join(mruby_path, "build", "ios", "lib", "libmruby.a")
ios_simulator_lib = File.join(mruby_path, "build", "ios-simulator", "lib", "libmruby.a")

lipo = %W(
  lipo
    #{ios_lib}
    #{ios_simulator_lib}
    -create
    -output #{File.join(mruby_build, "libmruby.a")}
)
system(*lipo) || raise("Failed creating mruby universal iOS library")

FileUtils.cp_r(File.join(mruby_path, "include", "."), File.join(mruby_build, "include"))

FileUtils.cd(build_dir)
