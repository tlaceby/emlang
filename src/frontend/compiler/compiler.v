module compiler

import frontend.parsers

pub struct EMCompiler {
	mut: parser parsers.Parser [required]
}

pub fn (mut c EMCompiler) emit_bytecode (entry parsers.SourceFile) {
	ast := c.parser.build_ast(entry)
	println(ast)
}
