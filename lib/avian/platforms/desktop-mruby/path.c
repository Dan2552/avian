#include "stdlib.h"

const char * game_resource_path(char *filename, char *filetype) {
  const char *home_directory = getenv("HOME");
  const char *rest = "/.avian/build/game_resources/font.ttf";
  return strcat(home_directory, rest);
}
