module s_expr

import frontend.ast
import frontend.parsers
import frontend.parsers.s_expr.lexer

pub struct SExprParser {
	mut: position u64
}

pub fn (mut parser SExprParser) build_ast (file parsers.SourceFile) ast.BlockStmt {
	mut tokenizer := lexer.construct_lexer(file)
	tokens := tokenizer.produce_tokens()

	for token in tokens {
		println(token)
	}

	return ast.BlockStmt{
		body: [],
	}
}


