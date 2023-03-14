module parsers

import frontend.ast

pub struct SourceFile {
	name string [required]
	path string [required]
	is_module bool
}

pub interface Parser {
	mut: build_ast (file SourceFile) ast.BlockStmt
}
