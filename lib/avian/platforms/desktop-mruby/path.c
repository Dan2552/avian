#include "stdlib.h"
#include <string.h>

const char * game_resource_path(char *filename, char *filetype) {
  return strcat(getenv("HOME"), "/.avian/build/game_resources/ankecallig-fg.ttf");
}
