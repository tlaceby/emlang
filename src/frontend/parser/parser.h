#pragma once

#include "ast.h"

class SExpParser {
public:
  SExpParser(const std::string &text) : text(text), position(0) {}
  std::shared_ptr<ASTNode> parse() { return parse_expression(); }

private:
  std::string text;
  size_t position;

  std::shared_ptr<ASTNode> parse_expression() {
    skip_whitespace();

    if (current() == '(') {
      return parse_list();
    } else if (current() == '#') {
      while (current() != '\n')
        position++;

      position++; // skip \n
      return parse_expression();
    } else if (current() == '"') {
      return parse_string();
    } else {
      return parse_atom();
    }
  }

  std::shared_ptr<ListNode> parse_list() {
    consume('(');
    auto list_node = std::make_shared<ListNode>();

    while (current() != ')') {
      list_node->children.push_back(parse_expression());
      skip_whitespace();
    }

    consume(')');
    return list_node;
  }

  std::shared_ptr<StringNode> parse_string() {
    consume('"');
    std::ostringstream str;

    while (current() != '"') {
      str << current();
      position++;
    }

    consume('"');
    return std::make_shared<StringNode>(str.str());
  }

  std::shared_ptr<ASTNode> parse_atom() {
    size_t start = position;

    while (position < text.size() && !isspace(current()) && current() != '(' &&
           current() != ')') {
      position++;
    }

    std::string atom = text.substr(start, position - start);
    std::istringstream iss(atom);

    double number;
    if (iss >> number && iss.eof()) {
      return std::make_shared<NumberNode>(number);
    } else {
      return std::make_shared<SymbolNode>(atom);
    }
  }

  void skip_whitespace() {
    while (position < text.size() && isspace(current())) {
      position++;
    }
  }

  char current() { return position < text.size() ? text[position] : '\0'; }

  void consume(char expected) {
    if (current() != expected) {
      throw std::runtime_error("Unexpected character");
    }
    position++;
  }
};
