/*
 * Simple program to dump the apple array contents to stdout for verification.
 * Note that libsystem mucks with some of the fields before we can see them.
 */

#include <stdbool.h>
#include <stdio.h>

int main(__unused int argc, __unused char **argv, __unused char **environ,
         char **apple) {
  int i = 0;
  while (true) {
    char *curr = apple[i];
    if (curr == NULL) {
      break;
    } else {
      printf("%s\n", curr);
    }
    i++;
  }
  return 0;
}
