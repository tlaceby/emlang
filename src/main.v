module main

import frontend.parsers { SourceFile }
import frontend.parsers.s_expr { SExprParser }


fn main() {

	file := SourceFile{ name: "test.em", path: "./" }
	mut parser := SExprParser{}

	parser.build_ast(file)
}
