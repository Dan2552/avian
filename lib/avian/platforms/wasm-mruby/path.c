#include "stdlib.h"
#include <string.h>

const char * platform_game_resource_path(char *filename, char *filetype) {
  static char *game_resources = "./game_resources/";
  char *file = malloc(
    strlen(game_resources) +
    strlen(filename) +
    1 +
    strlen(filetype) +
    1
  );
  strcat(file, game_resources);
  strcat(file, filename);
  strcat(file, ".");
  strcat(file, filetype);
  return file;
}

const char * platform_documents_path() {
  static char *documents_folder = "./documents";
  char *file = malloc(strlen(documents_folder) + 1);
  strcat(file, documents_folder);
  return file;
}
