#include "stdlib.h"
#include <string.h>

const char * platform_game_resource_path(char *filename, char *filetype) {
  static char *game_resources = "/.avian/build/game_resources/";
  char *file = malloc(
    strlen(getenv("HOME")) +
    strlen(game_resources) +
    strlen(filename) +
    1 +
    strlen(filetype) +
    1
  );
  strcpy(file, getenv("HOME"));
  strcat(file, game_resources);
  strcat(file, filename);
  strcat(file, ".");
  strcat(file, filetype);
  return file;
}

const char * platform_documents_path() {
  static char *documents_folder = "/.avian/build/documents";
  char *file = malloc(strlen(getenv("HOME")) + strlen(documents_folder) + 1);
  strcpy(file, getenv("HOME"));
  strcat(file, documents_folder);
  return file;
}
