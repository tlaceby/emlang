#include "values.h"

void Val::print() {
  switch (kind) {
  case Number:
    printf("NumberVal: %d\n", as.number);
    break;
  case Null:
    printf("NullVal\n");
    break;
  case Heap:
    as.heap->print();
    break;
  default:
    printf("Unimplimented Print Method For Type %d\n", kind);
    exit(1);
  }
}