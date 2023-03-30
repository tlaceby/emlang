#include "util/cli.h"
#include <iostream>
#include <unistd.h>

//

int main(int argc, char **argv) {
  em::cli::args();
  int opt;
  while ((opt = getopt(argc, argv, "tp")) != -1) {
    switch (opt) {
    case 't':
      std::cout << "Time flag is set" << std::endl;
      break;
    case 'p':
      std::cout << "Prod flag is set" << std::endl;
      break;
    default:
      std::cerr << "Usage: " << argv[0] << " [-t] [-p]" << std::endl;
      return 1;
    }
  }

  // Your code here

  return 0;
}
