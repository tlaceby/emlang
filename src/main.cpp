#include "frontend/parser/parser.h"
#include <fstream>
#include <string>

int main() {
  std::ifstream ifs("./test.em");
  std::string content = "(program ";

  content += std::string((std::istreambuf_iterator<char>(ifs)),
                         (std::istreambuf_iterator<char>()));

  content += "\n)"; // add closing program

  SExpParser parser(content);
  auto ast = parser.parse();

  pretty_print_ast(ast);
  return 0;
}