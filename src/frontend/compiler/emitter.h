#pragma once
#include "../../backend/values/values.h"
#include "../parser/parser.h"

class Compiler {
private:
  size_t scope_level{0};
  shared_ptr<CodeVal> code;

public:
  Compiler();

  shared_ptr<CodeVal> compile(shared_ptr<ASTNode>);
};