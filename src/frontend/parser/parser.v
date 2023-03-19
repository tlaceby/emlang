module parser

import frontend.ast { Expr }
import frontend.parser.lexer { build_lexer, SourceFile , Token, TokenKind }

pub struct Parser {
mut:
	tokens []Token
	position int
}

pub fn (mut parser Parser) produce_ast (file SourceFile) Expr {
	mut lex := build_lexer(file) or {
		println(err)
		exit(1)
	}

	parser.tokens = lex.tokenize()

	node := parser.expression(0)
	return node
}

pub fn (mut parser Parser) expression (rbp int) Expr {
	mut tk := parser.current()
	mut nud := nud_lookup[tk.kind()]
	mut left := nud(mut parser)

	for parser.not_eof() && rbp < int(bp_lookup[tk.kind()]) {
		tk = parser.current()
		left = led_lookup[tk.kind()](mut parser, left, int(bp_lookup[tk.kind()]))
	}

	return left
}
