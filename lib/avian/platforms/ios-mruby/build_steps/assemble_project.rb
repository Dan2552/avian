require 'fileutils'

avian_root = ENV['AVIAN_ROOT']
ios_platform_dir = File.join(avian_root, "lib", "avian", "platforms", "ios-mruby")
build_dir = File.join(ENV["HOME"], ".avian", "build")
xcode_project_dir = File.join(build_dir, "ios", "xcode_project")
template_dir = File.join(ios_platform_dir, "template")
shared_dir = File.join(avian_root, "lib", "avian", "platforms", "shared-mruby")

library_files = [
  File.join(build_dir, "ios", "sdl", "ios-build", "lib", "libSDL2.a"),
  File.join(build_dir, "ios", "sdl-gpu", "libSDL2_gpu.a"),
  File.join(build_dir, "ios", "sdl_image", "Xcode-iOS", "build", "Release-fat", "libSDL2_image.a"),
  File.join(build_dir, "ios", "sdl_ttf", "Xcode", "build", "Release-fat", "libSDL2_ttf.a"),
  File.join(build_dir, "ios", "mruby", "libmruby.a")
]

FileUtils.cp_r(template_dir, xcode_project_dir) unless File.directory?(xcode_project_dir)

target_libraries_dir = File.join(xcode_project_dir, "PROJECTNAME", "PROJECTNAME", "Libraries")

FileUtils.mkdir_p(File.join(target_libraries_dir, "files"))
library_files.each do |file|
  FileUtils.cp(file, File.join(target_libraries_dir, "files"))
end

FileUtils.mkdir_p(File.join(target_libraries_dir, "include", "libSDL2"))
FileUtils.mkdir_p(File.join(target_libraries_dir, "include", "libSDL2_gpu"))
FileUtils.mkdir_p(File.join(target_libraries_dir, "include", "libSDL2_image"))
FileUtils.mkdir_p(File.join(target_libraries_dir, "include", "libSDL2_ttf"))
FileUtils.mkdir_p(File.join(target_libraries_dir, "include", "libmruby"))

FileUtils.cp_r(File.join(build_dir, "ios", "sdl", "include", "."), File.join(target_libraries_dir, "include", "libSDL2"))
FileUtils.cp_r(File.join(build_dir, "ios", "sdl-gpu", "include", "."), File.join(target_libraries_dir, "include", "libSDL2_gpu"))
Dir.glob(File.join(build_dir, "ios", "sdl_image", "*.h")).each do |sdl_image_header|
  FileUtils.cp_r(sdl_image_header, File.join(target_libraries_dir, "include", "libSDL2_image"))
end
Dir.glob(File.join(build_dir, "ios", "sdl_ttf", "*.h")).each do |sdl_image_header|
  FileUtils.cp_r(sdl_image_header, File.join(target_libraries_dir, "include", "libSDL2_ttf"))
end
FileUtils.cp_r(File.join(build_dir, "ios", "mruby", "include", "."), File.join(target_libraries_dir, "include", "libmruby"))

FileUtils.cp(File.join(build_dir, "app.c"), File.join(xcode_project_dir, "PROJECTNAME", "PROJECTNAME", "app.h"))
FileUtils.cp(File.join(shared_dir, "main.c"), File.join(xcode_project_dir, "PROJECTNAME", "PROJECTNAME", "main.c"))
FileUtils.cp(File.join(ios_platform_dir, "path.h"), File.join(xcode_project_dir, "PROJECTNAME", "PROJECTNAME", "path.h"))
FileUtils.cp(File.join(ios_platform_dir, "path.m"), File.join(xcode_project_dir, "PROJECTNAME", "PROJECTNAME", "path.m"))
FileUtils.cp(File.join(ios_platform_dir, "options.h"), File.join(xcode_project_dir, "PROJECTNAME", "PROJECTNAME", "options.h"))

FileUtils.cp_r(File.join(build_dir, "ios", "sdl_ttf", "Xcode", "iOS", "FreeType.framework", "."), File.join(xcode_project_dir, "PROJECTNAME", "PROJECTNAME", "FreeType.framework"))

source = File.join(build_dir, "game_resources", ".")
destination = File.join(xcode_project_dir, "PROJECTNAME", "PROJECTNAME", "game_resources")
FileUtils.cp_r(source, destination)
