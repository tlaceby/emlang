module main

import frontend.parsers { SourceFile }
import frontend.compiler { EMCompiler }
import frontend.parsers.s_expr { SExprParser }



fn main() {
	file := SourceFile{ name: "test.em", path: "./" }
	mut emitter := EMCompiler { parser: SExprParser{} }
	emitter.emit_bytecode(file)
}
