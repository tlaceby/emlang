package main

import (
	"github.com/davecgh/go-spew/spew"
)

type Foo struct {
	bar string
}

func main() {
	foo := Foo{bar: "Baz"}
	spew.Dump(foo)
}
