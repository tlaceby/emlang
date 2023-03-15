module compiler

import frontend.parsers
import vm.values { EmValue, CodeVal }

pub struct EMCompiler {
mut:
	parser parsers.Parser [required]
	code CodeVal
}

pub fn (mut c EMCompiler) emit_bytecode (entry parsers.SourceFile) CodeVal {
	ast := c.parser.build_ast(entry)
	println(ast)

	return c.code
}
