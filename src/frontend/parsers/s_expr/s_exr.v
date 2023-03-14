module s_expr

import frontend.ast
import frontend.parsers

pub struct SExprParser {
	mut: position u64
}

pub fn (mut parser SExprParser) build_ast (file parsers.SourceFile) ast.BlockStmt {
	parser.position = 1
	println(file)
	return ast.BlockStmt{
		body: [],
	}
}


