#ifndef emlang_ast
#define emlang_ast

#include <iostream>
#include <memory>
#include <sstream>
#include <string>
#include <vector>

// Base AST node class
class ASTNode {
public:
  virtual ~ASTNode() = default;
};

// AST node for symbols
class SymbolNode : public ASTNode {
public:
  SymbolNode(const std::string &value) : value(value) {}

  std::string value;
};

// AST node for strings
class StringNode : public ASTNode {
public:
  StringNode(const std::string &value) : value(value) {}

  std::string value;
};

// AST node for numbers
class NumberNode : public ASTNode {
public:
  NumberNode(double value) : value(value) {}

  double value;
};

// AST node for lists
class ListNode : public ASTNode {
public:
  std::vector<std::shared_ptr<ASTNode>> children;
};

void pretty_print_ast(const std::shared_ptr<ASTNode> &node, int indent = 0) {
  if (auto symbolNode = std::dynamic_pointer_cast<SymbolNode>(node)) {
    std::cout << std::string(indent, ' ') << "Symbol: " << symbolNode->value
              << std::endl;
  } else if (auto stringNode = std::dynamic_pointer_cast<StringNode>(node)) {
    std::cout << std::string(indent, ' ') << "String: \"" << stringNode->value
              << "\"" << std::endl;
  } else if (auto numberNode = std::dynamic_pointer_cast<NumberNode>(node)) {
    std::stringstream ss;
    ss.setf(std::ios::fixed);
    ss.precision(2);
    ss << numberNode->value;
    std::cout << std::string(indent, ' ') << "Number: " << ss.str()
              << std::endl;
  } else if (auto listNode = std::dynamic_pointer_cast<ListNode>(node)) {
    std::cout << std::string(indent, ' ') << "List:" << std::endl;
    for (const auto &child : listNode->children) {
      pretty_print_ast(child, indent + 2);
    }
  } else {
    std::cout << std::string(indent, ' ') << "Unknown node type" << std::endl;
  }
}

#endif