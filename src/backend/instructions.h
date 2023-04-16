#pragma once
#include "cstdint"

enum Op {
  HLT,
  PUSH,
  PUSHM,
  POP,
  POP_M,

  LOAD_CONST,
  SET_GLOBAL,
  LOAD_GLOBAL,
  SET_LOCAL,
  LOAD_LOCAL,
};

typedef uint8_t Instruction;