module compiler

import frontend.parser.lexer { SourceFile }
import frontend.parser { Parser }
import vm.values { EmValue, CodeVal }

pub struct EMCompiler {
mut:
	parser Parser
	code CodeVal
}

pub fn (mut c EMCompiler) emit_bytecode (entry SourceFile) CodeVal {
	ast := c.parser.produce_ast(entry)

	println(ast)
	return c.code
}
