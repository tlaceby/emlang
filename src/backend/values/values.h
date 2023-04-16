#pragma once
#include "../instructions.h"
#include "stdio.h"
#include <memory>
#include <string>
#include <vector>

using std::shared_ptr;

enum ValueKind {
  Number,
  Heap,
  Null,
};

enum HeapKind {
  Code,
  String,
};

struct HeapVal {
  HeapKind kind;
  virtual void print() = 0;
};

struct Val {
  ValueKind kind;
  union as {
    double number;
    HeapVal *heap;
  } as;

  void print();
};

// Heap Allocated
struct StringVal : public HeapVal {
  HeapKind kind{String};
  std::string value;

  StringVal(std::string &str) : value(str) {}
  void print() { printf("StringVal: %s\n", value.c_str()); }
};

struct GlobalVal {
  Val value;
  std::string name;
};

struct CodeVal : public HeapVal {
  HeapKind kind{Code};
  std::string name;
  std::vector<Val> constants;
  std::vector<Instruction> instructions;
  std::vector<GlobalVal> globals;

  CodeVal(std::string &name) : name(name) {}
  void print() { printf("CodeBlock(%s)\n", name.c_str()); }
};