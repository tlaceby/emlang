module parser

import frontend.ast { Stmt, BlockStmt, VarDeclarationStmt }
import frontend.parser.lexer { TokenKind }
pub fn (mut parser Parser) statement () Stmt {
	tk := parser.current()

	if tk.kind() in stmt_lookup {



		return stmt_lookup[tk.kind()](mut parser)
	}

	expr := parser.expression(0)
	parser.expect(.semicolon)
	return expr
}

pub fn (mut parser Parser) block () Stmt {
	parser.expect(.open_bracket)
	mut block := []Stmt{}

	for parser.current().kind() != .close_bracket && parser.not_eof() {
		block << parser.statement()
	}

	parser.expect(.close_bracket)
	return BlockStmt{ body: block }
}

// Builder Functions


fn stmt (id TokenKind, s_fn STMT_FN) {
	symbol(id, .default)
	stmt_lookup[id] = s_fn
}

fn block (mut parser &Parser) Stmt {
	return parser.block()
}

fn variable_declaration (mut parser &Parser) Stmt {
	local := parser.advance().kind() == .local
	identifier := parser.expect(.symbol).val()
	parser.expect(.equals)
	rhs := parser.expression(0)
	parser.expect(.semicolon)

	return VarDeclarationStmt {
		local: local,
		ident: identifier,
		rhs: rhs
	}
}
